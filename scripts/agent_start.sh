#!/usr/bin/env bash
set -euo pipefail

# Agent start script: activate venv, ensure artifacts exist, and start dev server.
# Designed to be run by background agent tooling from project root.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Activate venv if present
if [ -f .venv/bin/activate ]; then
  # shellcheck disable=SC1091
  source .venv/bin/activate
  echo "[agent_start] Activated venv"
else
  echo "[agent_start] No venv found; continuing without venv"
fi

# If artifacts missing, run build (this may be long)
if [ ! -d web-stable-diffusion/web/dist ] || [ -z "$(ls -A web-stable-diffusion/web/dist 2>/dev/null)" ]; then
  echo "[agent_start] Artifacts missing — running build (this may take a while)"
  ./web-stable-diffusion/scripts/build.sh
fi

# Start the dev server
echo "[agent_start] Starting dev server"
./web-stable-diffusion/scripts/start-dev.sh
