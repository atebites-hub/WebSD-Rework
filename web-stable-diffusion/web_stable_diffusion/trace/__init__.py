# FX compatibility shim for TVM v0.21 + PyTorch 2.x
# Rationale: TVM's Relax frontend struggles with newer FX graph representations
# (e.g., TorchDynamo-wrapped ops and dynamic shape metadata). This shim
# disables aggressive TorchDynamo caching and suppresses unsupported type
# errors, allowing the importer to gracefully fall back to standard FX nodes.
try:
    import torch._dynamo
    torch._dynamo.config.suppress_errors = True
    torch._dynamo.config.cache_size_limit = 1
except ImportError:
    pass

from .model_trace import *
from .scheduler_trace import Scheduler, DPMSolverMultistepScheduler, PNDMScheduler
from .scheduler_trace import compute_save_scheduler_consts, schedulers
