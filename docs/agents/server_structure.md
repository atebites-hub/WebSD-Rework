# Server Structure — Web Stable Diffusion (Rework)

This repository ships a browser-only demo at runtime; there is no persistent application server required to generate images. The Python stack is used at build-time to compile models to WebGPU-compatible artifacts.

## Architecture Summary
- Build-time: Python + PyTorch + Apache TVM v0.21 compile pipeline produces:
  - Model library wasm: `stable_diffusion_webgpu.wasm`, `stable_diffusion_xl.wasm`.
  - NDArray parameter shards and metadata (per submodule sizes).
  - Scheduler constant JSON files.
- Runtime: Static hosting of the web app and artifacts; tvmjs executes compiled kernels on the client’s GPU via WebGPU.

## Build Pipeline Responsibilities
- Trace SD components (CLIP/UNet/VAE/schedulers) from PyTorch using TorchDynamo/FX.
- Apply Relax transforms and MetaSchedule database.
- Export library for `target=webgpu` to `.wasm`.
- Dump parameter shards and scheduler constants using `tvm.contrib.tvmjs` helpers.

## Hosting Options
- Local development: `web-stable-diffusion/web` served by static file server.
- GitHub Pages or any static host for production demo.
- Required files under `web-stable-diffusion/web/dist/` plus parameter shard directories referenced by the config JSON.

## Configuration
- A deployment step provides `stable-diffusion-config.json` (alias of `local-config.json` or `gh-page-config.json`) to select wasm and shard locations.

## Security Considerations
- Serve artifacts over HTTPS; restrict CORS to expected origins (or host all assets together).
- No user data is sent to servers; generation occurs in-browser.
- Tokenizer JSON fetched from a trusted source (e.g., Hugging Face) over HTTPS.

## Edge Cases & Recovery
- If any asset fetch fails, surface a retry option and keep UI responsive.
- If WebGPU device initialization fails, show guidance to enable/upgrade browser or GPU drivers.

## Optional Utilities
- Debug RPC or profiling helpers may exist to benchmark kernels; these are not required for the demo and should be gated behind dev-only builds.
