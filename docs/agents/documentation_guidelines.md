# Documentation Guidelines — Web Stable Diffusion (Rework)

Standards for writing and maintaining documentation and code comments.

## Structure
- `/docs/agents/`: Context and planning docs (this file, tech stack, requirements, implementation plan, client/server, file structure, app flow, testing guidelines).
- `/docs/code/`: Per-module docs with Mermaid diagrams, public APIs, and examples.
- `/docs/tests/`: Testing docs and coverage summaries.

## Code Docstrings
- JavaScript (JSDoc) and Python (Google style) for public functions and modules.
- Include: Description, Preconditions, Postconditions, Parameters, Returns, Raises, Examples.

## Generation
- Python: Sphinx with `sphinx-autodoc-typehints` for API docs.
- JS: JSDoc for public APIs used by web runtime.

## Quality Gates
- Docs updated as part of PRs that change code.
- Coverage: At least 80% of new public APIs documented.
- Links and code samples must build or run where applicable.

## Diagrams
- Use Mermaid for high-level architecture and pipelines (Relax transforms, VM functions, scheduler flows).

## Deprecations
- Mark deprecated modules with reasons and removal plan; remove stale references across docs.
