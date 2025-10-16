# [Project Name]

[Brief 1-2 sentence overview of the project. E.g., "[Project Name] is a [type: web app/API/game] that [core purpose], built with [key tech]."]

## Quick Start
1. Clone the repo: `git clone [repo-url]`.
2. Install dependencies: Run `/scripts/setup.sh` (or `npm install` for JS, `pip install -r requirements.txt` for Python).
3. Set up environment: Copy `.env.example` to `.env` and fill in values.
4. Launch dev mode: `./scripts/run-dev.sh`.
5. Run tests: `./scripts/test-suite.sh`.

## Project Structure
Follow the layout in `/docs/agents/file_structure_doc.md` for modularity.

## Key Documents
- **AGENTS.md**: Rules for AI agents (e.g., Cursor, Claude).
- **Memory System**: Tasks and progress via per-task memories and agent todos.
- **Implementation Plan**: Sprint roadmap in `/docs/agents/implementation_plan.md`.

## Contributing
- Reference AGENTS.md for scope.
- Run tests before PRs.
- Update docs/code/tests as per `/docs/agents/documentation_guidelines.md`.

## License
[License: e.g., MIT]

Assumptions: [e.g., "Node.js v18+"]; Known Issues: [e.g., "Beta mobile support"].