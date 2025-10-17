# TVM Build Notes (v0.21) — Web Stable Diffusion

This file records notes for building Apache TVM v0.21 for the Web Stable Diffusion smoke-build script.

Key points
- Target TVM tag: `v0.21.0`
- Required toolchain: LLVM 16/17 (the script attempts to use `llvm-config` or falls back to `/usr/bin/llvm-config-16`).
- Emscripten (emsdk) is required for producing WASM artifacts; the smoke-build script installs and activates the latest emsdk in `$HOME/emsdk`.
- The script installs TVM into the active Python environment via `python -m pip install -e tvm/python`.

Troubleshooting tips
- If CMake fails due to missing LLVM, install `llvm-16`/`llvm-17` via apt or use upstream LLVM apt packages.
- Large builds may require >32GB RAM; consider disabling autotvm/meta-schedule flags to reduce memory.
- If WebGPU/Emscripten build fails, fallback to building native CPU artifacts and run `deploy.py` locally to validate the pipeline.

Files created by the smoke-build script
- `dist/` — expected output artifacts (WASM, `tvmjs_runtime` bundles, params)
- `/var/log/websd_build/` — build logs (timestamped)
- `tvm/` — cloned TVM source (if not already present)

See `scripts/ci/smoke_build_ubuntu_24_04.sh` for the exact non-interactive commands used by the smoke-build plan.
