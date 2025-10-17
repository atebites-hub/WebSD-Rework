import os
import traceback

import pytest

try:
    import torch
    import torch._dynamo as dynamo
except Exception:
    torch = None
    dynamo = None


def _dump_trace(exc: Exception) -> None:
    os.makedirs("logs", exist_ok=True)
    with open("logs/torchdynamo_repro.log", "w") as f:
        f.write("Captured exception trace:\n")
        traceback.print_exc(file=f)


@pytest.mark.timeout(120)
def test_torchdynamo_backendcompilerfailed_repro():
    """Minimal reproducer that attempts to exercise a function-type embedding in outputs.

    Behavior:
    - Skips if `torch` or `torch._dynamo` are not available in the test environment.
    - Enables verbose torch-dynamo output and attempts to run `optimize` on a model
      whose forward returns a Python function as part of its output. This is intended
      to reproduce the `AssertionError: Unsupported function type embedding` /
      `torch._dynamo.exc.BackendCompilerFailed` failure seen in CI.
    - On exception, the full traceback is written to `logs/torchdynamo_repro.log`.
    """
    if torch is None or dynamo is None:
        pytest.skip("torch and torch._dynamo are required for this test")

    # Make Dynamo more verbose so internals are easier to inspect
    dynamo.config.verbose = True
    dynamo.config.suppress_errors = False

    class ReproModel(torch.nn.Module):
        def forward(self, x):
            # Intentionally include a Python callable in the outputs to provoke an
            # unsupported embedding/type path inside downstream compilers/importers.
            def inner(y):
                return y + 1

            return x + 1, inner

    model = ReproModel()
    inp = torch.randn(2, 2)

    try:
        wrapped = dynamo.optimize("aot_eager")(model)
        wrapped(inp)
    except Exception as e:
        _dump_trace(e)
        # Re-raise so pytest shows the failure and CI/test logs contain the traceback
        raise
