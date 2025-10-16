# AGENTS.md - Project Rules

## Guidelines for Filling Out This Template
- Replace [Project Name] with your project's name (e.g., "My API Service" or "Game App").
- Set [Number] to the count of core docs (default 9; adjust if needed).
- Customize consultation/quality gates for your domain (e.g., add "API rate limits" for server-heavy projects).
- For multi-agent use: Ensure links work across tools (e.g., mdc: for Markdown previews); test in Cursor/Claude.
- Reference repo structure: Store this as root/AGENTS.md; link to /file_structure.md for agent file impacts.
- When transforming this template repository into the user's desired repository, first consult with the user in detail their project requirements.
- For each template file being updated, iterate in detail with the user over each section, ensuring that the document matches the user's preferences.

## Memory System
This is a mandatory worklow executed when trigger conditions are met as follows:
   - Planning
   - Codebase or Web Search
   - Task Start
   - User Response
   - Todo List Completion
Every task an agent performs must be created and maintained as a `memory` within the `Memory System`. Every task must be a sprint task from `docs/agents/Implementation Plan.md`. See `docs/memory_template.md` for the template to fill when creating a new `memory`. See `Memory System Bindings` for tool bindings to conduct the workflow.

Workflow:
1. Retreive the task `memory` or create a new one if no relevant memory exists. 
2. Depending on the trigger condition, update the task `memory` with the relevant information.
   - Planning: Update Task, Context, Rules, and Evaluation sections with information from the conversation.
   - Codebase or Web Search: Update Analysis, Feedback, and Lessons sections with information from the search results.
   - Task Start: If on main branch, create a new branch, update the task `memory` state to `in_progress` and set the branch and head to the new branch and commit hash.
   - User Response: Update the following sections within the `memory` with relevant information from the chat: Analysis, Feedback, and Lessons
   - Todo List Completion: Update the task `memory` state to `completed` and set the pull request to the pull request url.

## Project Scope Definition

These rules define the limitations and scope for AI agents (e.g., Cursor, Claude, Cline, Kilo) working on [Project Name]. All work must align with the [Number] core documentation files in `/docs/agents/` that serve as the single source of truth for project requirements, architecture, and implementation guidelines. Agents from any tool must reference these rules as the project's global context boundary.

### Core Reference Documents

The following [Number] documents in `/docs/agents/` define your context boundary and must be referenced for all work:

1. **[Project Requirements Doc.md](mdc:docs/agents/Project Requirements Doc.md)** - Defines general requirements, high-level objectives, user flows, tech stack, and core features.
2. **[App Flow Doc.md](mdc:docs/agents/App Flow Doc.md)** - Describes user flows, data flows, and state transitions.
3. **[Tech Stack Doc.md](mdc:docs/agents/Tech Stack Doc.md)** - Describes technologies, dependencies, and APIs to be used.
4. **[Client Guidelines.md](mdc:docs/agents/Client Guidelines.md)** - Describes client styles, standards, and UI components.
5. **[Server Structure Doc.md](mdc:docs/agents/Server Structure Doc.md)** - Defines server architecture, security, and data management.
6. **[Implementation Plan.md](mdc:docs/agents/Implementation Plan.md)** - Provides breakdown into actionable sprints with TCREI task structure.
7. **[File Structure Doc.md](mdc:docs/agents/File Structure Doc.md)** - Defines how files should be organized in the project.
8. **[Testing Guidelines.md](mdc:docs/agents/Testing Guidelines.md)** - Describes test types, setup, and sprint-end checks.
9. **[Documentation Guidelines.md](mdc:docs/agents/Documentation Guidelines.md)** - Defines doc formats, policies, and maintenance.


## Development Workflow Requirements

### Before Starting Any Work

1. **Read Current State**: Identify the current sprint and task in `/docs/agents/implementation_plan.md`, then recall relevant memories using the platform’s memory tool (Cursor Memories or MCP Memory).
2. **Reference Documents**: Consult the [Number] core documents for requirements, flows, and standards.
3. **Task Structure**: Use TCREI format for all tasks (Task, Context, Rules, Examples, Iteration).
4. **Test Coverage**: Achieve 80%+ test coverage for new code; run `/scripts/test-suite.sh` before commits.
5. **Security Review**: Run security scans (e.g., [tool: cargo-audit for Rust, ESLint-plugin-security for JS]) before completion.


### Documentation Requirements

**MANDATORY**: Update documentation as you work:
- **Memory Records**: Persist decisions, lessons, and preferences using the platform’s memory tool (Cursor Memories or MCP Memory).
- **Code Documentation**: For every new/edit/deleted code file (e.g., `renderer.js`), create/update/delete the corresponding `/docs/code/renderer.md` with Mermaid diagram, description, and function breakdowns.
- **Test Documentation**: Update `/docs/tests/` (e.g., `unit.md`) for new tests, including run commands and edge cases.

**CRITICAL**: Ensure these tasks are done before marking your current objective as complete.
- **Task Completion**: Mark tasks complete in the agent todo system and persist a “Lesson: <topic>” memory; keep `/docs/agents/implementation_plan.md` current.
- **Agents**: As project scope changes, review and update all docs in `/docs/agents/` to match. Only edit with explicit user instruction.

## Consultation Requirements

**MANDATORY**: Consult the human user before:

1. **Working Outside Scope**: Any work not explicitly covered in the [Number] reference documents.
2. **Technology Changes**: Introducing new technologies or libraries.
3. **Architecture Modifications**: Changing server structure or file organization.
4. **Sprint Deviations**: Working on tasks outside current sprint in Implementation Plan.md.
5. **Security Exceptions**: Any deviation from security requirements.
6. **Feature Additions**: Adding features not listed in requirements.

## Quality Gates

### Before Marking Tasks Complete

1. **Unit Tests**: All tests pass with 80%+ coverage (run `/scripts/test-suite.sh`).
2. **Security Scan**: No high/critical vulnerabilities (e.g., [tool: cargo-audit] clean).
3. **Code Review**: Follow coding standards (e.g., docstrings with Description, Preconditions, Postconditions, Parameters, Returns).
4. **Documentation**: All code documented with proper docstrings; `/docs/code/` and `/docs/tests/` updated.
5. **Integration**: Works with existing system components.
6. **Audit Compliance**: Meets security and compliance requirements.

---

**Critical**: These rules serve as your context boundary. Performing work outside these boundaries risks breaking the project's architecture and may compromise the system. Always consult before proceeding with any work not explicitly covered in the reference documents.