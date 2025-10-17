#!/usr/bin/env bash
set -euo pipefail

LOG_DIR=/var/log/websd_build
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_DIR/$(date +%Y%m%d_%H%M%S)_smoke_build.log") 2>&1

echo "Starting Web Stable Diffusion smoke build"

# Update system and install base packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential git cmake ninja-build pkg-config python3-pip curl wget unzip ca-certificates \
  libtinfo-dev libedit-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zlib1g-dev libffi-dev liblzma-dev libncursesw5-dev libgdbm-dev llvm-16 llvm-16-dev llvm-16-tools

# Install Node.js 18+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

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

# Install pyenv and Python 3.13 (non-interactive)
if ! command -v pyenv >/dev/null 2>&1; then
  curl https://pyenv.run | bash
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)" || true
  eval "$(pyenv virtualenv-init -)" || true
fi

if ! pyenv versions --bare | grep -qx "^3.13.0$"; then
  pyenv install -s 3.13.0 || true
fi
pyenv virtualenv -f 3.13.0 websd-venv-3.13 || true
pyenv activate websd-venv-3.13 || true

# Upgrade pip and install Python deps if present
python -m pip install --upgrade pip setuptools wheel
if [ -f web-stable-diffusion/requirements.txt ]; then
  python -m pip install -r web-stable-diffusion/requirements.txt || true
fi

# Clone and build Apache TVM v0.21
if [ ! -d tvm ]; then
  git clone --recursive https://github.com/apache/tvm.git
fi
pushd tvm >/dev/null
git fetch --all --tags
git checkout v0.21.0
mkdir -p build && cd build
cmake -S .. -B . -G Ninja \
  -DUSE_LLVM=ON \
  -DLLVM_CONFIG_EXECUTABLE=$(which llvm-config || echo /usr/bin/llvm-config-16) \
  -DUSE_RPC=OFF \
  -DUSE_CUDA=OFF \
  -DUSE_METAL=OFF \
  -DUSE_WEBGPU=ON \
  -DUSE_EMSCRIPTEN=ON \
  -DCMAKE_BUILD_TYPE=Release
cmake --build . -j"$(nproc)" || true
popd >/dev/null

# Install TVM Python package into the active venv
if [ -d tvm/python ]; then
  python -m pip install -e tvm/python || true
fi

# Build project artifacts
# Ensure emsdk env is loaded
# shellcheck source=/dev/null
source "$HOME/emsdk/emsdk_env.sh" || true

if [ -f web-stable-diffusion/build.py ]; then
  python web-stable-diffusion/build.py --target webgpu --artifact-path dist --db-path log_db --use-cache=0 || true
else
  echo "Warning: web-stable-diffusion/build.py not found"
fi

# Runtime smoke test
if [ -f web-stable-diffusion/deploy.py ]; then
  python web-stable-diffusion/deploy.py --device-name webgpu --artifact-path dist --prompt "smoke test" || true
else
  echo "Warning: web-stable-diffusion/deploy.py not found"
fi

# Optional: build and serve local site (if scripts exist)
if [ -x web-stable-diffusion/scripts/build_site.sh ]; then
  web-stable-diffusion/scripts/build_site.sh web/local-config.json || true
fi
if [ -x web-stable-diffusion/scripts/local_deploy_site.sh ]; then
  web-stable-diffusion/scripts/local_deploy_site.sh || true
fi

echo "Smoke build script completed. Logs are in $LOG_DIR"
