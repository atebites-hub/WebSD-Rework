# Project Requirements — Web Stable Diffusion (Rework)

This document defines the scope, objectives, constraints, and acceptance criteria for refactoring Web Stable Diffusion to run with Apache TVM v0.21.0 and WebGPU in modern browsers, with a forward-compat Python toolchain.

## Objectives
:- Upgrade compile/runtime stack to Apache TVM v0.21.0 and the upgraded tvmjs web runtime.
:- Support Stable Diffusion v1.5 and SDXL pipelines end-to-end in-browser using WebGPU.
:- Maintain forward compatibility goals while locking the project toolchain to Python 3.13 to match PyTorch 2.7 compatibility.
:- Replace any brittle or obsolete code with systematic, maintainable implementations; no mocks to “just compile”.

## In Scope
:- Python compile pipeline using PyTorch → TVM Relax → WebGPU `.wasm` output.
:- Web UI and tvmjs runtime integration for model loading, scheduling, and rendering to canvas.
:- Parameter packaging (NDArray caches), scheduler constants, tokenizer integration.
:- Automated tests (unit/integration/e2e), CI, and security scans.
:- Documentation updates across tech stack, app flow, file structure, client/server guides.

## Out of Scope (Initial Phase)
:- Model training or fine-tuning.
:- Native desktop/mobile packaging.
:- Non-WebGPU backends (e.g., WebGL); we may error with guidance when unsupported.

## Non-Functional Requirements
:- Performance: 20-step DPM solver path executes without runtime errors and renders frames progressively; SDXL path validated for correctness on supported devices.
:- Browser Support: Any browser with WebGPU enabled. Clear user guidance if unsupported.
:- Reliability: Deterministic initialization and cleanup with proper memory scoping in tvmjs.
:- Security: Static asset delivery with integrity checks; no dynamic code loading beyond wasm/runtime.

## Constraints and Risks
:- Python 3.13 is the project toolchain target to remain compatible with PyTorch 2.7; upgrades to newer Python versions should be planned and validated separately.
:- TVM v0.21 FFI and web runtime changes may require updating generated artifacts and JS glue.
:- Asset size and network constraints (parameter shards) require progressive UX and caching guidance.

## Acceptance Criteria
:- Local demo renders images for SD 1.5 and SDXL flows in a WebGPU-enabled browser using TVM v0.21 artifacts.
:- CI runs tests (>=80% coverage of new Python and JS modules), lint checks, and a headless e2e smoke that validates a minimal generation.
:- Documentation complete: technology stack, project requirements, implementation plan, client guidelines, server structure, file structure, app flow, documentation and testing guidelines.

## Tech Stack & APIs (Summary)
:- Python 3.13 (target); PyTorch 2.7; Apache TVM v0.21; tvmjs web runtime; WebGPU; Emscripten for wasm.

## User Flows (High-Level)
1. User opens the web demo; the page fetches tvmjs runtime and the model wasm.
2. WebGPU device is detected; if present, the VM is created and parameter shards are fetched.
3. User enters prompt and triggers generation; CLIP → UNet+Scheduler → VAE run on WebGPU; output drawn to canvas.

## References
:- Apache TVM v0.21.0 Release Notes: [link](https://github.com/apache/tvm/releases/tag/v0.21.0)
