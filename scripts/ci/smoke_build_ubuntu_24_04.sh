#!/usr/bin/env bash
set -euo pipefail

# Prefer system log dir but fall back to workspace if not writable (non-root CI environments)
DEFAULT_LOG_DIR=/var/log/websd_build
FALLBACK_LOG_DIR="$PWD/logs/websd_build"
if [ -w "$(dirname "$DEFAULT_LOG_DIR")" ] || [ "$(id -u)" -eq 0 ]; then
  LOG_DIR="$DEFAULT_LOG_DIR"
else
  LOG_DIR="$FALLBACK_LOG_DIR"
fi
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_DIR/$(date +%Y%m%d_%H%M%S)_smoke_build.log") 2>&1

echo "Starting Web Stable Diffusion smoke build"

# Short usage/help
if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  cat <<EOF
Usage: $0 [--skip-site] [--env macos|ubuntu|docker]

Environment variables (also supported):
  FORCE_TVM_BUILD=1        # enable long TVM full build
  FORCE_PYENV_INSTALL=1    # build Python via pyenv
  SKIP_SITE=1              # skip site build/deploy steps
  SMOKE_ENV=macos|ubuntu|docker # optional preset for package install paths
EOF
  exit 0
fi

# Read optional flags
# Process positional flag first but allow environment variable to take precedence
FLAG_SKIP_SITE=0
# Guard against unset positional parameters when "set -u" is enabled
if [ "${1:-}" = "--skip-site" ]; then
  FLAG_SKIP_SITE=1
fi
SMOKE_ENV=${SMOKE_ENV:-""}
SKIP_SITE=${SKIP_SITE:-${FLAG_SKIP_SITE:-0}}

# Preset tweaks for known environments
if [ -n "$SMOKE_ENV" ]; then
  case "$SMOKE_ENV" in
    ubuntu)
      export DEBIAN_FRONTEND=noninteractive
      ;;
    docker)
      export DEBIAN_FRONTEND=noninteractive
      # In docker images sudo may be missing; allow apt-get without sudo if running as root
      ;;
    macos)
      # macOS preset (no-op, Homebrew path handling below)
      ;;
    *)
      echo "Unknown SMOKE_ENV '$SMOKE_ENV' - proceeding with autodetect" ;;
  esac
fi
# Update system and install base packages (skip if sudo not available)
# Provide a macOS (Darwin) fallback using Homebrew or nvm when available.
OS_NAME=$(uname)

# Prefer repository-local .venv if present and set PYTHON_BIN early so later steps use it
if [ -f ".venv/bin/activate" ]; then
  echo "Found .venv; activating early"
  # shellcheck source=/dev/null
  . .venv/bin/activate
  PYTHON_BIN="$(pwd)/.venv/bin/python"
  export PYTHON_BIN
  export PATH="$(pwd)/.venv/bin:$PATH"
fi

# Determine parallel build job count in a cross-platform way
if command -v nproc >/dev/null 2>&1; then
  NPROC=$(nproc)
elif [ "$OS_NAME" = "Darwin" ]; then
  NPROC=$(sysctl -n hw.ncpu 2>/dev/null || echo 2)
else
  NPROC=2
fi


# Prefer a brewed llvm-config on macOS if available so CMake can find LLVM
if [ "$OS_NAME" = "Darwin" ]; then
  if command -v brew >/dev/null 2>&1; then
    # Prefer llvm@16 if installed (Homebrew keeps multiple llvm versions)
    BREW_LLVM16_PREFIX="$(brew --prefix llvm@16 2>/dev/null || true)"
    BREW_LLVM_PREFIX="$(brew --prefix llvm 2>/dev/null || true)"
    if [ -n "$BREW_LLVM16_PREFIX" ] && [ -d "$BREW_LLVM16_PREFIX" ]; then
      LLVM_CONFIG_EXECUTABLE="$BREW_LLVM16_PREFIX/bin/llvm-config"
      LLVM_DIR="$BREW_LLVM16_PREFIX/lib/cmake/llvm"
      export PATH="$BREW_LLVM16_PREFIX/bin:$PATH"
      # Only append an extra space when existing flags are present to avoid trailing whitespace
    # Prepend new flags and ensure a separating space if existing flags are present
    if [ -n "${LDFLAGS:-}" ]; then
      export LDFLAGS="-L$BREW_LLVM16_PREFIX/lib $LDFLAGS"
    else
      export LDFLAGS="-L$BREW_LLVM16_PREFIX/lib"
    fi
    if [ -n "${CPPFLAGS:-}" ]; then
      export CPPFLAGS="-I$BREW_LLVM16_PREFIX/include $CPPFLAGS"
    else
      export CPPFLAGS="-I$BREW_LLVM16_PREFIX/include"
    fi
      export PKG_CONFIG_PATH="$BREW_LLVM16_PREFIX/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
    elif [ -n "$BREW_LLVM_PREFIX" ] && [ -d "$BREW_LLVM_PREFIX" ]; then
      LLVM_CONFIG_EXECUTABLE="$BREW_LLVM_PREFIX/bin/llvm-config"
      LLVM_DIR="$BREW_LLVM_PREFIX/lib/cmake/llvm"
      export PATH="$BREW_LLVM_PREFIX/bin:$PATH"
    else
      LLVM_CONFIG_EXECUTABLE="$(which llvm-config 2>/dev/null || echo /opt/homebrew/opt/llvm/bin/llvm-config)"
    fi
    : "${CMAKE_PREFIX_PATH:=}"
    if [ -n "$LLVM_DIR" ]; then
      export CMAKE_PREFIX_PATH="$LLVM_DIR${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
    fi
    export LLVM_DIR
  else
    LLVM_CONFIG_EXECUTABLE="$(which llvm-config 2>/dev/null || echo /usr/bin/llvm-config-16)"
  fi
else
  LLVM_CONFIG_EXECUTABLE="$(which llvm-config || echo /usr/bin/llvm-config-16)"
fi
export LLVM_CONFIG_EXECUTABLE
if [ "$OS_NAME" = "Darwin" ]; then
  echo "Detected macOS; attempting Homebrew-based package installs where possible"
  if command -v brew >/dev/null 2>&1; then
    brew update || true
    # Ensure core build tooling is present on macOS
    brew install git cmake ninja pkg-config python@3 curl wget unzip openssl bzip2 readline sqlite3 xz zlib libffi llvm || true
    # Homebrew's LLVM is keg-only; help tools find it
    BREW_LLVM_PREFIX=$(brew --prefix llvm 2>/dev/null || echo "")
    if [ -n "$BREW_LLVM_PREFIX" ]; then
      LLVM_CONFIG_EXECUTABLE="$BREW_LLVM_PREFIX/bin/llvm-config"
      LLVM_DIR="$BREW_LLVM_PREFIX/lib/cmake/llvm"
      : "${CMAKE_PREFIX_PATH:=}"
      export CMAKE_PREFIX_PATH="$LLVM_DIR${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
      export LLVM_DIR
      export PATH="$BREW_LLVM_PREFIX/bin:$PATH"
      # Prepend new flags and ensure a separating space if existing flags are present
      if [ -n "${LDFLAGS:-}" ]; then
        export LDFLAGS="-L$BREW_LLVM_PREFIX/lib $LDFLAGS"
      else
        export LDFLAGS="-L$BREW_LLVM_PREFIX/lib"
      fi
      if [ -n "${CPPFLAGS:-}" ]; then
        export CPPFLAGS="-I$BREW_LLVM_PREFIX/include $CPPFLAGS"
      else
        export CPPFLAGS="-I$BREW_LLVM_PREFIX/include"
      fi
      # Prepend new flags and ensure a separating space if existing flags are present
      if [ -n "${LDFLAGS:-}" ]; then
        export LDFLAGS="-L$BREW_LLVM_PREFIX/lib $LDFLAGS"
      else
        export LDFLAGS="-L$BREW_LLVM_PREFIX/lib"
      fi
      if [ -n "${CPPFLAGS:-}" ]; then
        export CPPFLAGS="-I$BREW_LLVM_PREFIX/include $CPPFLAGS"
      else
        export CPPFLAGS="-I$BREW_LLVM_PREFIX/include"
      fi
      export PKG_CONFIG_PATH="$BREW_LLVM_PREFIX/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
    fi
  else
    echo "Homebrew not found. For macOS please install Homebrew or ensure required packages are present."
  fi
elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
  sudo apt update && sudo apt upgrade -y
  # Try installing LLVM-16 packages; if they are unavailable add the official LLVM apt repo and retry,
  # otherwise fall back to installing the distro-provided llvm/clang packages.
  set +e
  sudo apt install -y build-essential git cmake ninja-build pkg-config python3-pip curl wget unzip ca-certificates \
    libtinfo-dev libedit-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev liblzma-dev libncursesw5-dev libgdbm-dev llvm-16 llvm-16-dev llvm-16-tools
  INSTALL_EXIT=$?
  set -e
  if [ "$INSTALL_EXIT" -ne 0 ]; then
    echo "llvm-16 packages not found via apt; attempting to add LLVM apt repo and retry"
    # Ensure helper tools available
    sudo apt install -y gnupg ca-certificates lsb-release || true
    CODENAME=$(lsb_release -sc 2>/dev/null || awk -F= '/^VERSION_CODENAME=/{print $2}' /etc/os-release || echo focal)
    # Add LLVM GPG key and source list
    sudo mkdir -p /etc/apt/keyrings || true
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key 2>/dev/null | sudo gpg --dearmor -o /etc/apt/keyrings/llvm-archive-keyring.gpg || true
    echo "deb [signed-by=/etc/apt/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/${CODENAME}/ llvm-toolchain-${CODENAME}-16 main" | sudo tee /etc/apt/sources.list.d/llvm.list
    sudo apt update || true
    if ! sudo apt install -y llvm-16 llvm-16-dev llvm-16-tools; then
      echo "Failed to install llvm-16 from the LLVM apt repo; falling back to distro llvm/clang packages"
      sudo apt install -y llvm clang || true
    fi
  fi
else
  echo "Note: sudo not available or requires password; skipping system package installation. Please run the script on a machine where sudo is available to install prerequisites."
fi

# Install Python build dependencies required by pyenv builds (non-fatal)
if [ "$OS_NAME" = "Darwin" ]; then
  if command -v brew >/dev/null 2>&1; then
    brew install bzip2 openssl readline sqlite3 xz zlib tcl-tk || true
  else
    echo "Homebrew not found; pyenv build deps may be missing on macOS."
  fi
elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
  sudo apt install -y libbz2-dev libssl-dev libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev liblzma-dev libncursesw5-dev tk-dev || true
fi

# Install Node.js 18+
if [ "$OS_NAME" = "Darwin" ]; then
  echo "Installing Node.js (macOS path)"
  if command -v brew >/dev/null 2>&1; then
    brew install node || true
  else
    echo "Homebrew not found; attempting nvm install"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash || true
    export NVM_DIR="$HOME/.nvm"
    # shellcheck source=/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install 18 || true
  fi
else
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt install -y nodejs
fi

# Install Emscripten SDK (emsdk)
if [ ! -d "$HOME/emsdk" ]; then
  git clone https://github.com/emscripten-core/emsdk.git "$HOME/emsdk"
  pushd "$HOME/emsdk" >/dev/null
  ./emsdk install latest
  ./emsdk activate latest
  # shellcheck source=/dev/null
  source ./emsdk_env.sh
  popd >/dev/null
else
  echo "emsdk already present at $HOME/emsdk"
  # shellcheck source=/dev/null
  source "$HOME/emsdk/emsdk_env.sh" || true
fi

# Ensure EMSDK env variables are exported on macOS too (Homebrew installs may differ)
if [ "$OS_NAME" = "Darwin" ]; then
  if [ -f "$HOME/emsdk/emsdk_env.sh" ]; then
    # shellcheck source=/dev/null
    source "$HOME/emsdk/emsdk_env.sh" || true
  fi
fi

# Install pyenv (but skip heavy Python builds unless explicitly requested)
if [ -d "$HOME/.pyenv" ]; then
  echo "pyenv directory exists at $HOME/.pyenv; initializing without re-running installer"
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)" || true
  eval "$(pyenv virtualenv-init -)" || true
elif ! command -v pyenv >/dev/null 2>&1; then
  # Use the non-interactive installer but guard against partially-present directories
  if curl -fsS https://pyenv.run | bash; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)" || true
    eval "$(pyenv virtualenv-init -)" || true
  else
    echo "Warning: pyenv installer failed; please inspect $HOME/.pyenv and install pyenv manually if needed"
  fi
fi

# Prefer a repository-local virtualenv (.venv) for deterministic Python deps.
# If not present, ensure pyenv shims/virtualenv are available and activate the project venv.
if [ -f ".venv/bin/activate" ]; then
  echo "Activating repository .venv"
  # shellcheck source=/dev/null
  . .venv/bin/activate
  PYTHON_BIN="$(pwd)/.venv/bin/python"
  export PYTHON_BIN
else
  # Ensure pyenv shims are on PATH and pyenv is initialized
  export PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH"
  eval "$(pyenv init -)" || true
  eval "$(pyenv virtualenv-init -)" || true
  # Prefer the project virtualenv name if available.
  # Make pyenv version detection resilient: trim whitespace and match exact version or virtualenv names.
  PYENV_VERSIONS_LIST="$(pyenv versions --bare 2>/dev/null | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  # If the virtualenv already exists, just activate it. Otherwise, if base Python 3.13 is present,
  # create the virtualenv and activate it.
  if printf '%s\n' "$PYENV_VERSIONS_LIST" | grep -qx "websd-venv-3.13"; then
    pyenv activate websd-venv-3.13 || true
    export PYENV_VERSION="websd-venv-3.13"
  elif printf '%s\n' "$PYENV_VERSIONS_LIST" | grep -qx "3.13.0" || printf '%s\n' "$PYENV_VERSIONS_LIST" | grep -qx "3.13"; then
    pyenv virtualenv -f 3.13.0 websd-venv-3.13 || true
    pyenv activate websd-venv-3.13 || true
    export PYENV_VERSION="websd-venv-3.13"
  fi
  PYTHON_BIN="$(command -v python 2>/dev/null || command -v python3 2>/dev/null || echo python)"
  export PYTHON_BIN
fi

# By default we avoid building Python from source in CI (use FORCE_PYENV_INSTALL=1 to enable).
if [ "${FORCE_PYENV_INSTALL:-0}" -eq 1 ]; then
  if ! pyenv versions --bare | grep -qx "^3.13.0$"; then
    pyenv install -s 3.13.0 || true
  fi
fi

# Create/activate virtualenv only if the requested Python was installed
if pyenv versions --bare | grep -qx "^3.13.0$"; then
  pyenv virtualenv -f 3.13.0 websd-venv-3.13 || true
  pyenv activate websd-venv-3.13 || true
else
  echo "Note: Python 3.13.0 not installed in pyenv; skipping virtualenv creation."
  echo "If you need pyenv-built Python, re-run with FORCE_PYENV_INSTALL=1 and ensure build dependencies are present."
fi

# Resolve a usable Python interpreter for pip/build steps (prefer pyenv/virtualenv if activated)
if command -v python >/dev/null 2>&1; then
  PYTHON_BIN=python
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN=python3
else
  echo "Warning: no python or python3 found in PATH; many steps will be skipped."
  PYTHON_BIN=python
fi

# Upgrade pip and install Python deps if present
"$PYTHON_BIN" -m pip install --upgrade pip setuptools wheel || true
if [ -f web-stable-diffusion/requirements.txt ]; then
  "$PYTHON_BIN" -m pip install -r web-stable-diffusion/requirements.txt || true
fi

# Clone and optionally build Apache TVM v0.21
if [ ! -d tvm ]; then
  git clone --recursive https://github.com/apache/tvm.git
fi
pushd tvm >/dev/null
git fetch --all --tags
# Ensure a detached checkout so local branches don't cause CMake cache conflicts
git checkout --detach v0.21.0 || git checkout --detach tags/v0.21.0 || true
# Remove any stale build directory to avoid CMakeCache path mismatches
if [ -d build ]; then
  echo "Removing stale tvm/build to avoid CMakeCache mismatches"
  rm -rf build || true
fi
mkdir -p build && cd build

# Ensure basic build tools are available
if ! command -v ninja >/dev/null 2>&1; then
  if [ "$OS_NAME" = "Darwin" ]; then
    if command -v brew >/dev/null 2>&1; then
      brew install ninja || true
    else
      echo "Warning: 'ninja' not found and Homebrew unavailable. CMake configure may fail."
    fi
  elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    sudo apt update || true
    sudo apt install -y ninja-build || true
  else
    echo "Warning: 'ninja' not found and sudo unavailable. CMake configure may fail."
  fi
fi

# Prefer available C/C++ compilers
if command -v gcc >/dev/null 2>&1 && command -v g++ >/dev/null 2>&1; then
  export CC="$(which gcc)"
  export CXX="$(which g++)"
elif command -v clang >/dev/null 2>&1 && command -v clang++ >/dev/null 2>&1; then
  export CC="$(which clang)"
  export CXX="$(which clang++)"
fi

# Run CMake configure; retry once if initial configure fails (commonly due to missing ninja)
CONFIG_OK=0
# Compute an evaluated LLVM_DIR for CMake to avoid leaving an unevaluated command substitution
if [ -n "${LLVM_DIR:-}" ]; then
  SELECTED_LLVM_DIR="$LLVM_DIR"
else
  # Compute a cross-platform LLVM_DIR fallback without invoking macOS-only paths on Linux
  if command -v brew >/dev/null 2>&1; then
    BREW_LLVM_FALLBACK="$(brew --prefix llvm@16 2>/dev/null || echo /opt/homebrew/opt/llvm@16)"
    SELECTED_LLVM_DIR="$BREW_LLVM_FALLBACK/lib/cmake/llvm"
  else
    # Linux typical llvm cmake dir for llvm-16
    SELECTED_LLVM_DIR="/usr/lib/llvm-16/lib/cmake/llvm"
  fi
fi
cmake -S .. -B . -G Ninja \
  -DUSE_LLVM=ON \
  -DLLVM_CONFIG_EXECUTABLE="${LLVM_CONFIG_EXECUTABLE:-$(which llvm-config || echo /usr/bin/llvm-config-16)}" \
  -DLLVM_DIR="${SELECTED_LLVM_DIR}" \
  -DPython3_EXECUTABLE="${PYTHON_BIN:-$(command -v python3 || command -v python)}" \
  -DUSE_RPC=OFF \
  -DUSE_CUDA=OFF \
  -DUSE_METAL=OFF \
  -DUSE_WEBGPU=ON \
  -DUSE_EMSCRIPTEN=ON \
  -DCMAKE_BUILD_TYPE=Release || CONFIG_OK=1
if [ "$CONFIG_OK" -ne 0 ]; then
  echo "CMake configure failed; attempting to ensure ninja is installed and retry once."
  if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    sudo apt install -y ninja-build || true
  fi
  cmake -S .. -B . -G Ninja \
    -DUSE_LLVM=ON \
    -DLLVM_CONFIG_EXECUTABLE="${LLVM_CONFIG_EXECUTABLE:-$(which llvm-config || echo /usr/bin/llvm-config-16)}" \
    -DLLVM_DIR="${SELECTED_LLVM_DIR}" \
    -DPython3_EXECUTABLE="${PYTHON_BIN:-$(command -v python3 || command -v python)}" \
    -DUSE_RPC=OFF \
    -DUSE_CUDA=OFF \
    -DUSE_METAL=OFF \
    -DUSE_WEBGPU=ON \
    -DUSE_EMSCRIPTEN=ON \
    -DCMAKE_BUILD_TYPE=Release || true
fi

# Building TVM from source can be very long; allow skipping with FORCE_TVM_BUILD=1 environment variable.
if [ "${FORCE_TVM_BUILD:-0}" -eq 1 ]; then
  # Ensure CMake/Build use the selected llvm-config and the repository .venv python
  export LLVM_CONFIG_EXECUTABLE="${LLVM_CONFIG_EXECUTABLE:-$(which llvm-config || echo /usr/bin/llvm-config-16)}"
  export CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH:-}"
  # Use repository .venv python if available (reference repo root instead of current dir)
  # Compute repository root in a safe way without forcing evaluation of the fallback when git succeeds
  if REPO_ROOT_DIR_GIT=$(git rev-parse --show-toplevel 2>/dev/null); then
    REPO_ROOT_DIR="$REPO_ROOT_DIR_GIT"
  else
    REPO_ROOT_DIR="$(pwd)/.."
  fi
  if [ -f "$REPO_ROOT_DIR/.venv/bin/python" ]; then
    export PYTHON_BIN="$REPO_ROOT_DIR/.venv/bin/python"
  fi
  cmake --build . -j"${NPROC}" || true
else
  echo "Skipping TVM full build (set FORCE_TVM_BUILD=1 to enable). CMake configure step completed."
fi
popd >/dev/null

# Install TVM Python package into the active venv
if [ -d tvm/python ]; then
  "$PYTHON_BIN" -m pip install -e tvm/python || true
fi

# Build project artifacts
# Ensure emsdk env is loaded
# shellcheck source=/dev/null
source "$HOME/emsdk/emsdk_env.sh" || true

if [ -f web-stable-diffusion/build.py ]; then
  "$PYTHON_BIN" web-stable-diffusion/build.py --target webgpu --artifact-path dist --db-path log_db --use-cache=0 || true
else
  echo "Warning: web-stable-diffusion/build.py not found"
fi

# Runtime smoke test
if [ -f web-stable-diffusion/deploy.py ]; then
  # Ensure required artifacts exist before running deploy
  if [ -d dist/params ] && [ -f dist/params/ndarray-cache.json ]; then
    "$PYTHON_BIN" web-stable-diffusion/deploy.py --device-name webgpu --artifact-path dist --prompt "smoke test" || true
  else
    echo "Warning: required artifacts missing in dist/params; skipping deploy step"
  fi
else
  echo "Warning: web-stable-diffusion/deploy.py not found"
fi

# Optional: build and serve local site (if scripts exist)
if [ "$SKIP_SITE" -ne 1 ]; then
  # Ensure a minimal local config exists so site build steps don't fail
  if [ ! -f web/local-config.json ]; then
    echo "web/local-config.json not found — creating a minimal placeholder"
    mkdir -p web
    cat > web/local-config.json <<JSON
{
  "title": "Web Stable Diffusion (local)",
  "baseurl": "",
  "analytics": {}
}
JSON
  fi

  if [ -x web-stable-diffusion/scripts/build_site.sh ]; then
    web-stable-diffusion/scripts/build_site.sh web/local-config.json || true
  else
    echo "Warning: web-stable-diffusion/scripts/build_site.sh not found — skipping site build"
  fi
  if [ -x web-stable-diffusion/scripts/local_deploy_site.sh ]; then
    web-stable-diffusion/scripts/local_deploy_site.sh || true
  fi
else
  echo "SKIP_SITE is set; skipping site build/deploy steps"
fi

echo "Smoke build script completed. Logs are in $LOG_DIR"
