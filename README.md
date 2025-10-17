# Web Stable Diffusion (Rework)

A comprehensive refactor of the Web Stable Diffusion demo to target Apache TVM v0.21.0, modern tvmjs WebGPU runtime, and a forward-compatible Python toolchain (target: Python 3.13). This repository contains the build-time Python pipeline that compiles PyTorch models into WebAssembly + WGSL shaders and a browser-based runtime that executes compiled Stable Diffusion pipelines on WebGPU-enabled clients.

## Quick Start (Developer)
1. Clone the repo: `git clone <repo-url>`
2. Set up Python environment (recommended using pyenv/venv):
   - Target Python: 3.13 (fallbacks are not expected; pin toolchain to 3.13 to match PyTorch 2.7)
   - Install Python deps: `pip install -r web-stable-diffusion/requirements.txt`
3. Install toolchain for TVM (see `/docs/agents/technology_stack.md` for details). Building TVM from source is required to produce the `tvmjs` runtime bundles for v0.21.
4. Build model artifacts (example):
   - `cd web-stable-diffusion`
   - `python build.py --target webgpu --artifact-path web/dist`
5. Serve the `web-stable-diffusion/web` directory via a static server during development:
   - `cd web-stable-diffusion/web`
   - `python -m http.server 8888`
6. Open `http://localhost:8888/stable_diffusion.html` in a WebGPU-capable browser (Chrome Canary or latest Chromium builds with WebGPU enabled).

## Project Structure (essential)
- `web-stable-diffusion/` - Python build pipeline, model tracing, TVM build scripts
- `web-stable-diffusion/web/` - Browser demo, deployment config, runtime bundles (dist/)
- `docs/agents/` - Project governance and implementation docs (tech stack, requirements, implementation plan, client/server guides, testing/docs guidelines)

## Key Documents
- `docs/agents/technology_stack.md` — planned stack, compatibility notes
- `docs/agents/project_requirements.md` — objectives and acceptance criteria
- `docs/agents/implementation_plan.md` — sprint roadmap (TCREI tasks)
- `docs/agents/client_guidelines.md` — frontend runtime and UX rules
- `docs/agents/server_structure.md` — build-time responsibilities and hosting
- `docs/agents/testing_guidelines.md` — test strategy and CI gates
- `docs/agents/documentation_guidelines.md` — docstring & generation standards

## Development Notes
- The demo relies on the tvmjs runtime. When upgrading TVM, rebuild `tvmjs_runtime.wasi.js` and `tvmjs.bundle.js` from TVM v0.21 sources.
- Tokenizer: the demo uses a rust-based tokenizer WASM (`tokenizers-wasm`) loaded at runtime.
- Parameter shards are large; for public demos consider hosting them on a CDN with SRI/content hash.

## Running Tests
- Python unit tests: `pytest web-stable-diffusion/tests/unit`
- JS unit/e2e: use Playwright/Jest as defined in `/docs/agents/testing_guidelines.md`.

## Contributing
- Follow the agent workflow in `AGENTS.md` and use TCREI for task decomposition.
- Update docs in `/docs/agents/` when adding or modifying features.
- Ensure >=80% coverage on new modules and run security scans before merging.

## License
MIT

## Smoke build (end-to-end)

Run the smoke build script to configure and (optionally) compile TVM, build web artifacts, and run a short smoke deploy.

Basic usage:

```bash
./scripts/ci/smoke_build_ubuntu_24_04.sh
```

Common environment flags:

- `FORCE_TVM_BUILD=1` — enable full TVM compilation (long-running)
- `FORCE_PYENV_INSTALL=1` — build Python via pyenv (optional)
- `SKIP_SITE=1` or `--skip-site` — skip site build/deploy steps
- `SMOKE_ENV=macos|ubuntu|docker` — optional environment preset

Example (macOS, full build):

```bash
SMOKE_ENV=macos FORCE_PYENV_INSTALL=1 FORCE_TVM_BUILD=1 ./scripts/ci/smoke_build_ubuntu_24_04.sh
```

The script prefers a repository `.venv` if present and will attempt to activate it; otherwise it will use pyenv-managed Python. On macOS the script prefers `llvm@16` when available and will attempt to use it for CMake.