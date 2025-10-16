# Project Requirements Template

This document outlines the high-level requirements, objectives, and scope for [Project Name], serving as the foundation for all development. It defines user needs, core features, and boundaries to guide sprints and agents.

## Guidelines for Filling Out This Template
- Replace [Project Name] with your project's name (e.g., "My API Service" or "Game App").
- Customize sections to your domain (e.g., for APIs: emphasize endpoints; for games: user flows).
- Use tables or lists for clarity (e.g., features table with priority columns).
- Keep in-scope/out-of-scope concise—aim for 5-10 items each to avoid scope creep.
- For agile projects: Tie features to sprints from Implementation Plan; add metrics (e.g., "80% test coverage").
- Include assumptions/known issues subsection for each major section to flag risks.
- Add Mermaid diagrams for high-level overviews (e.g., feature dependency graph).
- Reference repo structure: Store this in /docs/agents/project_requirements_doc.md; link to /file_structure.md for file impacts.

## Project Overview
[Brief 2-3 paragraph description of the project, its goals, and unique value. E.g., "[Project Name] is a [type: web app/API/game] that [core purpose], leveraging [key tech] for [benefit]. Include non-functional requirements like performance goals or constraints. Assumptions: [e.g., "Assumes mobile-first design"]; Known Issues: [e.g., "Offline caching limits"].

Mermaid Diagram: [e.g., graph TD; A[User Input] --> B[Core Logic]; B --> C[Output]; Assumptions: [e.g., "Stable inputs"]; Known Issues: [e.g., "Edge validation gaps"].]

## User Flows
[Step-by-step breakdown of key user journeys, using numbered lists or flowcharts. E.g., "1. User visits landing page and clicks Launch. 2. Prompts [auth] connection... Include error paths and assumptions. Assumptions: [e.g., "Assumes stable network"]; Known Issues: [e.g., "Touch lag on low-end devices"].

Mermaid Diagram: [e.g., sequenceDiagram; User->>App: Click Launch; App->>User: Load Screen; Assumptions: [e.g., "Browser support"]; Known Issues: [e.g., "Slow load on 3G"].]

## Tech Stack & APIs
[Table or list of technologies, with purposes and docs links. E.g., | Tech | Purpose | Docs | Include dependencies and constraints. Assumptions: [e.g., "Assumes Node.js v18+"]; Known Issues: [e.g., "Compatibility with older browsers"].

## Core Features
[List 5-10 prioritized features, with descriptions. E.g., - Feature 1: [Description]. Priority: High. Include assumptions or metrics. Assumptions: [e.g., "Assumes user auth"]; Known Issues: [e.g., "Scalability limits"].

Mermaid Diagram: [e.g., graph LR; F1[Feature 1] --> F2[Feature 2]; Assumptions: [e.g., "Sequential deps"]; Known Issues: [e.g., "Parallel execution bugs"].]

## In-Scope vs Out-of-Scope Items
- **In-Scope**: [List items for initial release, e.g., "Core [functionality] loop"].
- **Out-of-Scope**: [List deferred items, e.g., "Advanced [feature] integration"].
Assumptions: [e.g., "In-scope focuses on MVP"]; Known Issues: [e.g., "Out-of-scope may require future sprints"].