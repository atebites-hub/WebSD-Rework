TVM v0.21 Build Docker

This directory contains a reproducible Dockerfile and build script to compile Apache TVM v0.21 and produce tvmjs runtime bundles for the web demo.

Files
- `Dockerfile` - Ubuntu-based image that installs build deps, Emscripten, clones TVM v0.21, builds it, and installs the Python package.
- `build-tvmjs.sh` - Driver script run inside the container to validate TVM python import and (placeholder) produce `tvmjs` artifacts under `/workspace/web-stable-diffusion/web/dist`.

Usage
1. Build the Docker image (run from repo root):
   ```bash
   docker build -t websd-tvm:v0.21 -f docker/tvm-v0.21/Dockerfile .
   ```

2. Run the container (mount workspace to persist artifacts):
   ```bash
   docker run --rm -it -v "$(pwd)":/workspace websd-tvm:v0.21
   ```

Notes & Next steps
- The `build-tvmjs.sh` currently contains placeholder steps for generating `tvmjs_runtime.wasi.js` and `tvmjs.bundle.js` because the exact bundling commands may depend on local TVM/Emscripten versions and project-specific scripts.
- Replace the placeholder section with a call to `web_stable_diffusion/build.py --target webgpu --artifact-path /workspace/web-stable-diffusion/web/dist` once the build pipeline is validated in-container.
- Building TVM from source is resource-intensive. Use CI runners or powerful hosts.
- For continuous reproducibility, consider pinning Emscripten and LLVM versions and caching build artifacts via Docker build cache layers.
