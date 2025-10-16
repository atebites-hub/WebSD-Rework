# Testing Guidelines — Web Stable Diffusion (Rework)

Test strategy and quality gates for the refactor.

## Tools
- Python: pytest + pytest-cov, bandit, safety.
- JS: Jest (unit), Playwright (e2e), eslint-plugin-security.

## Types
- Unit (Python): utils (params IO), Relax transformation helpers, build orchestration.
- Unit (JS): scheduler wiring functions, progress callbacks.
- Integration: Python build to `.wasm` + shard dump; JS loads wasm and resolves VM functions.
- E2E: Headless browser runs Generate for SD 1.5 and SDXL minimal steps; assert canvas receives non-trivial image data.
- Security: Static scans for Python/JS dependencies and linting rules.

## Coverage
- New code: >= 80% line coverage.
- Critical modules (build pipeline, JS runtime glue): targeted tests for error paths.

## CI
- On PR: run unit → integration → e2e; enforce coverage + vulnerability gates (no high/critical findings).
- Artifacts: store Playwright traces on failures.

## Performance Baselines
- Demo initial load under reasonable network (artifacts cached locally); UNet loop executes without blocking UI thread beyond progress updates.

## Maintenance
- Update tests when VM function names or parameter metadata change.
- Keep small golden outputs or numeric ranges for regression checks.
