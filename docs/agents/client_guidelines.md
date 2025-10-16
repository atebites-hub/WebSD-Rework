# Client Guidelines — Web Stable Diffusion (Rework)

Standards for the browser client that hosts the tvmjs WebGPU runtime and Stable Diffusion UI.

## UI Architecture
- Page: `web-stable-diffusion/web/stable_diffusion.html` loads tvmjs runtime bundles and `dist/stable_diffusion.js`.
- Canvas: Single `<canvas id="canvas">` bound by `tvm.bindCanvas(...)` for rendering results.
- Controls: Text inputs for prompt/negative prompt, scheduler selector, and a Generate button bound to `tvmjsGlobalEnv.asyncOnGenerate`.
- Tokenizer: `tokenizers-wasm` is imported as an ES module and exposed via `tvmjsGlobalEnv.getTokenizer`.

## Styling & Layout
- Keep layout minimal to reduce reflows during rendering; avoid heavy DOM operations while inference runs.
- Canvas should scale responsively within a centered container.

Example CSS:
```css
#canvas { width: 100%; max-width: 640px; height: auto; display: block; margin: 0 auto; }
#progress { max-width: 640px; margin: 8px auto; }
```

## Runtime Integration Rules
- Initialization
  - Fetch model wasm and instantiate tvmjs with WASI; detect WebGPU, call `tvm.initWebGPU(device)`.
  - Fetch NDArray cache shards via `tvm.fetchNDArrayCache(url, tvm.webgpu())`.
  - Create VM via `tvm.createVirtualMachine(tvm.webgpu())`, then resolve compiled entrypoints with `vm.getFunction(name)`.
- Memory Scoping
  - Use `tvm.beginScope()`/`tvm.endScope()` around batched operations and `tvm.withNewScope()` for short-lived allocations.
  - Detach results that must survive asynchronous awaits; dispose deterministic resources on reset.
- Parameters
  - Use `tvm.getParamsFromCache(submoduleName, sizeFromMetadata)` as provided by `tvm.cacheMetadata`.
- Schedulers
  - Load scheduler constants from JSON; pick implementation by selector (DPM, PNDM, Euler for SDXL).

## Performance Guidance
- Avoid re-rendering UI during UNet loops; update progress UI via a compact callback (text + progress value) only.
- Prefer a single `await device.sync()` per iteration or batched syncs to reduce stalls.
- Keep logs concise; throttle debug output.

## Error Handling & UX
- If WebGPU is unavailable or initialization fails, show a clear message with guidance to enable WebGPU.
- On artifact fetch failure (wasm/params), present actionable error states (retry, network check) without crashing.
- Provide a Reset action that disposes VM functions, params, and tvm instance.

## Accessibility
- Label inputs and controls (`aria-label` / visible labels).
- Ensure color contrast for progress text.

## Browser Support
- Target modern browsers with WebGPU. Feature-detect via tvmjs or navigator.gpu; avoid UA string checks.

## Security
- Host artifacts over HTTPS; enable CORS only where needed for parameter shards.
- Consider integrity checks (hash-based filenames or SRI) for runtime bundles and wasm.
