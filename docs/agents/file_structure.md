# File Structure — Web Stable Diffusion (Rework)

Canonical layout of the repository and where build artifacts and web assets live.

## Root Layout (abridged)
```text
/ (repo)
├─ AGENTS.md
├─ docs/
│  └─ agents/
│     ├─ technology_stack.md
│     ├─ project_requirements.md
│     ├─ implementation_plan.md
│     ├─ client_guidelines.md
│     ├─ server_structure.md
│     ├─ file_structure.md
│     ├─ app_flow.md
│     ├─ documentation_guidelines.md
│     └─ testing_guidelines.md
├─ scripts/
├─ source/
│  ├─ client/
│  └─ server/
├─ tests/
│  ├─ unit/
│  ├─ integration/
│  └─ security/
└─ web-stable-diffusion/
   ├─ build.py
   ├─ deploy.py
   ├─ web/
   │  ├─ stable_diffusion.html
   │  ├─ local-config.json
   │  ├─ gh-page-config.json
   │  └─ dist/                # runtime bundles + model wasm + scheduler JSON
   ├─ web_stable_diffusion/   # python build modules
   │  ├─ models/
   │  ├─ runtime/
   │  ├─ trace/
   │  └─ utils.py
   └─ tests/
```

## Build Outputs
- Web runtime bundles: `web-stable-diffusion/web/dist/tvmjs_runtime.wasi.js`, `tvmjs.bundle.js`.
- Model libraries: `web-stable-diffusion/web/dist/stable_diffusion_webgpu.wasm`, `stable_diffusion_xl.wasm`.
- Scheduler constants: JSON files under `web-stable-diffusion/web/dist/`.
- Parameter shards: directories referenced by config (e.g., `web-sd-shards-v1-5/`, `web-sd-shards-xl/`).

## Conventions
- Use content-hashed filenames for public deployments where possible.
- Keep web assets under `web-stable-diffusion/web/` to simplify static hosting.
