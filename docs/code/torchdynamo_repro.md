Reproducing torch-dynamo BackendCompilerFailed / "Unsupported function type embedding"

Purpose
- Capture a minimal unit test that reproduces the `AssertionError: Unsupported function type embedding`
  (or `torch._dynamo.exc.BackendCompilerFailed`) observed in CI smoke builds.

Files added
- `tests/test_torchdynamo_repro.py` — pytest test that attempts to compile a small model whose
  forward returns a Python callable as part of its outputs. When the failure occurs the test
  writes a full traceback to `logs/torchdynamo_repro.log`.

How to run locally
1. Create a Python venv and install project test deps plus PyTorch with a compatible version.
2. From repository root run:

```bash
pytest -q tests/test_torchdynamo_repro.py -k backendcompilerfailed --maxfail=1
```

3. If the failure is reproduced, inspect `logs/torchdynamo_repro.log` for full stack traces and
   TorchDynamo diagnostics.

Notes
- The test will be skipped if `torch` or `torch._dynamo` are not available in the environment.
- If CI or local runs use a different torch/torchdynamo backend name, adjust the `dynamo.optimize`
  backend string in the test accordingly.
- Next steps: enhance the test to capture `torch._dynamo` statistics and FX graphs when the failure
  occurs, and attach the captured artifacts to the PR for analysis.
