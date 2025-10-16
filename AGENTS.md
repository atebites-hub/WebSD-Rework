# AGENTS.md - Project Rules

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

These rules define the limitations and scope for AI agents working on Web Stable Diffusion (Rework). All work must align with the 9 core documentation files in `/docs/agents/`.

### Core Reference Documents

1. **[Project Requirements.md](mdc:docs/agents/project_requirements.md)**
2. **[App Flow.md](mdc:docs/agents/app_flow.md)**
3. **[Technology Stack.md](mdc:docs/agents/technology_stack.md)**
4. **[Client Guidelines.md](mdc:docs/agents/client_guidelines.md)**
5. **[Server Structure.md](mdc:docs/agents/server_structure.md)**
6. **[Implementation Plan.md](mdc:docs/agents/implementation_plan.md)**
7. **[File Structure.md](mdc:docs/agents/file_structure.md)**
8. **[Testing Guidelines.md](mdc:docs/agents/testing_guidelines.md)**
9. **[Documentation Guidelines.md](mdc:docs/agents/documentation_guidelines.md)**

## Development Workflow Requirements

### Before Starting Any Work
1. Read current sprint and task in `/docs/agents/implementation_plan.md`; recall task memory.
2. Consult the 9 core documents for requirements and standards.
3. Use TCREI for tasks; follow test coverage and security review gates.

### Documentation Requirements
- Memory records persist decisions and lessons.
- Update `/docs/code/` for changed modules (Python build pipeline and JS runtime); include Mermaid diagrams and API breakdowns.
- Update `/docs/tests/` as tests are added.

## Consultation Requirements
- Confirm before scope, technology, architecture, sprint deviations, security exceptions, or feature additions.

## Quality Gates
- Unit tests: >=80% coverage for new code; run `/scripts/test-suite.sh`.
- Security scan: No high/critical vulnerabilities.
- Code review: Docstrings include Description/Preconditions/Postconditions/Parameters/Returns.
- Documentation: `/docs/code/` and `/docs/tests/` updated.
- Integration: Web demo functional with TVM v0.21 artifacts and WebGPU.
- Audit compliance: Security and compliance requirements met.

---

**Critical**: These rules serve as your context boundary. Performing work outside these boundaries risks breaking the project's architecture and may compromise the system. Always consult before proceeding with any work not explicitly covered in the reference documents.