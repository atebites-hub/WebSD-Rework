# App Flow — Web Stable Diffusion (Rework)

This document narrates the runtime flow from page load to image rendering in the browser.

## Launch Flow
1. User opens the demo page (`stable_diffusion.html`).
2. The page loads tvmjs runtime bundles and the tokenizer WASM module.
3. A deployment-provided `stable-diffusion-config.json` is fetched to resolve:
   - Scheduler constants URLs
   - Tokenizer names
   - Model wasm URL(s)
   - Parameter shard base URL(s)
4. The app fetches the model wasm and instantiates tvmjs with WASI.
5. WebGPU device is detected; `tvm.initWebGPU(device)` is called or the app fails with a clear message.
6. NDArray parameter shards are fetched and cached on the device.
7. A Virtual Machine is created; compiled entrypoints (CLIP/UNet/VAE/etc.) are looked up.

## Generation Flow
1. User enters prompt (and optional negative prompt), chooses scheduler, and clicks Generate.
2. CLIP encodes prompts to embeddings (and pooled embeddings for SDXL).
3. UNet iterative denoising runs for the selected number of steps, using the chosen scheduler. Progress is updated.
4. VAE decodes the final latents to an image tensor.
5. The image is converted to RGBA and drawn to the bound canvas.

## Error Paths
- WebGPU unavailable → show guidance to enable WebGPU or use a supported browser.
- Artifact fetch failures → show retry and diagnostics (which file failed).
- VM function missing → reset pipeline and surface a bug report link.

## Clean-up
- Reset disposes the pipeline, VM functions, params, and tvm instance to reclaim memory.
