# Sprint 0 — Task 2 Findings: TVM v0.21 build & tvmjs runtime

## Summary
We must build Apache TVM v0.21 from source to generate `tvmjs` runtime bundles (`tvmjs_runtime.wasi.js`, `tvmjs.bundle.js`) and produce model `.wasm` artifacts for the web runtime. The repository documents this requirement in several places and expects `web_stable_diffusion/build.py` to drive compilation to `webgpu` with `export_library`.

## Evidence found in repository
- `docs/agents/implementation_plan.md` lists Task 2 and notes smoke build testing.
- `docs/agents/technology_stack.md` and `file_structure.md` reference `tvmjs` runtime bundles and artifact names.
- `README.md` instructs building model artifacts via `python build.py --target webgpu --artifact-path web/dist` and states TVM build is required to produce `tvmjs` bundles.
- `docs/agents/server_structure.md` references `tvm.contrib.tvmjs` helpers for dumping NDArray parameter caches.

## Commands / Steps (documented)
1. Install TVM build dependencies (see `docs/agents/technology_stack.md`).
2. Build Apache TVM v0.21 from source with WebGPU + WASI/Emscripten support.
3. Use TVM python pipeline (`web_stable_diffusion/build.py`) to trace models and call `export_library(..., target="webgpu")` producing `.wasm` and tvmjs-compatible artifacts.
4. Bundle tvmjs runtime (Emscripten outputs) into `web/dist/tvmjs_runtime.wasi.js` and `tvmjs.bundle.js`.

## Risks and notes
- Building TVM from source is resource- and time-intensive; CI or local dev machines must have required compilers and libraries.
- If a prebuilt tvmjs runtime for v0.21 is available from a trusted source, consider using it to accelerate development while validating integration.

## Next steps
- Decide whether to attempt a local build in this environment (requires large build time), or to document a reproducible containerized build (recommended).
- If user confirms, I can produce a Dockerfile and driven build steps for TVM v0.21 + tvmjs artifacts.

---

(Links and code references added to the task memory.)