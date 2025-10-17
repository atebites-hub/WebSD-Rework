# Sprint 0 — PyTorch vs Python 3.13 Findings

**Summary**
- Project decision: target **Python 3.13** with **PyTorch 2.7** to maintain compatibility and streamline CI.
- PyTorch 2.7 releases on PyPI generally cover up to CPython 3.12/3.13 in binary wheels; newer torch minor releases (e.g., 2.9.0) provide CPython 3.14 wheels.
- Working in Python 3.13 removes the need to build PyTorch from source and aligns with the project's stated PyTorch 2.7 requirement.

**Details**
- I inspected PyPI metadata for `torch` and observed that `torch==2.9.0` includes `cp314` wheel filenames, but `2.7.x` releases do not consistently include `cp314` wheels.
- The repository's current environment here is Python 3.13.3; CI and Docker images should be updated to `python:3.13` to ensure reproducibility.

**Implication for project**
- Lock the project toolchain to Python 3.13 and PyTorch 2.7. This reduces CI fragility and avoids time-consuming source builds of PyTorch.
- If a later decision upgrades PyTorch to 2.9+ (or newer), we can reassess moving to Python 3.14.

**Recommended next steps**
- Update CI images, `pyproject`/`requirements`/`Dockerfile` to use `python:3.13` and `torch==2.7.x` as appropriate.
- Run the build pipeline on a Python 3.13 runner and execute a smoke compile to ensure TVM Relax transforms and `export_library` succeed with PyTorch 2.7.
- Document the upgrade path in `docs/agents/implementation_plan.md` for future movement to Python 3.14.

**Artifacts & Notes**
- Memory entry: `docs/memories/sprint0_task1_pytorch_3_14.md` (recorded decision).
- Findings saved at `docs/findings/sprint0_pytorch_3_14_findings.md`.
