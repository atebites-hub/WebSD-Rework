# Implementation Plan — Web Stable Diffusion (Rework)

Agile plan with sprints and tasks to refactor the project to Apache TVM v0.21.0, modern tvmjs, and WebGPU. Tasks follow TCREI and align with repository structure.

## Sprint 0: Baseline & Environment
Goals: Decide Python version pin (Python 3.13 target), lock toolchain, capture risks.
Duration: 1 week.
Tasks:
1. Verify PyTorch support; project decision: target Python 3.13 with PyTorch 2.7. Document upgrade path to 3.14 if/when required.
2. Confirm TVM v0.21 build from source and tvmjs runtime bundle generation.
3. Finalize documentation scaffolding (this plan, tech stack, requirements).
Testing: Smoke build of TVM runtime; doc lint.

## Sprint 1: TVM v0.21 + tvmjs Runtime Upgrade
Goals: Build tvmjs artifacts from TVM v0.21; ensure WebGPU device init works.
Duration: 1-2 weeks.
Tasks:
1. Build and publish `tvmjs_runtime.wasi.js` and `tvmjs.bundle.js` from v0.21 sources.
2. Replace any deprecated tvmjs calls; validate `instantiate`, `initWebGPU`, `createVirtualMachine`, `asyncLoadWebGPUPipelines`.
3. Wire SRI/hash-based static delivery.
Testing: Browser feature-detection tests, basic VM function lookup.

## Sprint 2: Python Compile Pipeline Update
Goals: Align `build.py` and transforms with TVM v0.21 APIs.
Duration: 1-2 weeks.
Tasks:
1. Update Relax transforms and MetaSchedule integration; validate `export_library` to `.wasm` for `webgpu` target.
2. Regenerate NDArray parameter caches and scheduler JSON.
3. Add unit tests for utils: save/load params, split transform/deploy.
Testing: pytest unit tests; inspect shaders (optional debug dumps).

## Sprint 3: Web Runtime Glue & UI Stabilization
Goals: Ensure JS runtime matches v0.21 behavior and memory scoping.
Duration: 1 week.
Tasks:
1. Validate VM functions for CLIP/UNet/VAE/schedulers in SD 1.5 path.
2. Confirm NDArray cache metadata sizes and lookups.
3. Improve progress callbacks and error messages.
Testing: Headless browser smoke to invoke `generate()` and detect canvas updates.

## Sprint 4: SD 1.5 End-to-End
Goals: SD 1.5 pipeline functional in WebGPU.
Duration: 1-2 weeks.
Tasks:
1. Verify scheduler steps (DPM, PNDM) and intermediate VAE draw.
2. Validate image output consistency (qualitative + numeric range checks).
Testing: e2e test to trigger generation and assert image buffer non-triviality.

## Sprint 5: SDXL End-to-End
Goals: SDXL pipeline functional (dual-CLIP, pooled embeddings, extra inputs).
Duration: 1-2 weeks.
Tasks:
1. Implement SDXL-specific VM function wiring and additional tensors (e.g., pooled embeddings, time ids).
2. Validate scheduler path (Euler discrete for current impl) and outputs.
Testing: e2e test with SDXL config.

## Sprint 6: Artifacts & Packaging
Goals: Clean parameter sharding, hosting layout, caching guidance.
Duration: 1 week.
Tasks:
1. Finalize `/web/dist` wasm names and shard directories; update config JSON.
2. Add integrity metadata and cache-busting strategy.
Testing: Offline reload and shard fetch tests.

## Sprint 7: Robustness & UX
Goals: Clear diagnostics, graceful fallbacks, consistent logging.
Duration: 1 week.
Tasks:
1. Feature detection UX for WebGPU and tokenizer fetch errors.
2. Memory scope audits to prevent leaks; deterministic dispose paths.
Testing: Stress and leak checks; error-path e2e tests.

## Sprint 8: CI/CD & Quality Gates
Goals: Automated tests, security scans, coverage enforcement.
Duration: 1 week.
Tasks:
1. GitHub Actions: unit (pytest/Jest), e2e (Playwright), security (bandit/safety/eslint-security).
2. Coverage >=80% for new code.
Testing: CI green on PRs.

## Sprint 9: Documentation & Handoff
Goals: Complete docs and code docs for changed modules.
Duration: 3-5 days.
Tasks:
1. Update `/docs/code/` for Python build pipeline and JS runtime modules.
2. Final pass on tech stack, project requirements, app flow, file structure, client/server guides.
Testing: Doc link checks; lint.
