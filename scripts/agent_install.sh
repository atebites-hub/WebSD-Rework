#!/usr/bin/env bash
set -euo pipefail

# Agent install script: prepare venv, install deps, and build artifacts if needed.
# Designed to be run by background agent tooling from project root.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "[agent_install] Making scripts executable"
chmod +x ./scripts/*.sh || true
chmod +x ./web-stable-diffusion/scripts/*.sh || true

# 1) Create and activate venv
if [ ! -d .venv ]; then
  echo "[agent_install] Creating Python venv"
  python3 -m venv .venv
fi
# shellcheck disable=SC1091
source .venv/bin/activate

# 2) Upgrade pip and install Python deps
echo "[agent_install] Installing Python dependencies"
python -m pip install --upgrade pip setuptools wheel
if [ -f web-stable-diffusion/requirements.txt ]; then
  pip install -r web-stable-diffusion/requirements.txt
else
  echo "[agent_install] No requirements.txt found at web-stable-diffusion/requirements.txt — skipping"
fi

# 3) Install optional JS deps if package.json present
if [ -f web-stable-diffusion/web/package.json ]; then
  if command -v npm >/dev/null 2>&1; then
    echo "[agent_install] Installing JS dependencies"
    (cd web-stable-diffusion/web && npm ci)
  else
    echo "[agent_install] npm not found — skipping JS dependencies"
  fi
fi

# 4) Build artifacts if dist is missing or empty
if [ ! -d web-stable-diffusion/web/dist ] || [ -z "$(ls -A web-stable-diffusion/web/dist 2>/dev/null)" ]; then
  echo "[agent_install] Build artifacts missing — running build.sh"
  ./web-stable-diffusion/scripts/build.sh
else
  echo "[agent_install] Artifacts present — skipping build"
fi

# 5) Summary
echo "[agent_install] Install complete. Activate venv: source .venv/bin/activate"
