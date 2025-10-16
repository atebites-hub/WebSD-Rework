# App Flow Template

This document describes the user interface flows, state transitions, and data interactions for [Project Name], ensuring seamless navigation and consistency.

## Guidelines for Filling Out This Template
- Replace [Project Name] with your project's name.
- Use simple, narrative language—no bullets; be painfully specific (e.g., "User clicks button X, screen Y appears").
- For multi-page/SPA apps: Detail page transitions; for games: Describe state loops (e.g., exploring to [action]).
- Include error paths (e.g., "If offline, show cached view").
- Adapt for tech: For PWAs, note Service Worker caching; for APIs, focus on request/response flows.
- Add diagrams (Mermaid flowcharts) for complex paths.
- Reference repo structure: Store this in /docs/agents/app_flow_doc.md; link to /file_structure.md for UI file locations.

## [Section: e.g., Launching the App]
[Narrative description of flow, e.g., "User opens browser and navigates to the site... Include data interactions and error handling. Assumptions: [e.g., "Assumes browser support"]; Known Issues: [e.g., "Slow load on 3G"].

Mermaid Diagram: [e.g., sequenceDiagram; User->>App: Click Launch; App->>User: Load Screen; Assumptions: [e.g., "Stable deps"]; Known Issues: [e.g., "Auth timeout"].]

## [Section: e.g., Core App Loop]
[Detailed step-by-step, e.g., "The loop renders [element], then captures input... Describe state transitions. Assumptions: [e.g., "Assumes 60fps"]; Known Issues: [e.g., "Input lag on touch"].

Mermaid Diagram: [e.g., graph TD; Loop[Render] --> Input[Capture]; Input --> Update[State]; Update --> Loop; Assumptions: [e.g., "Async safe"]; Known Issues: [e.g., "Race conditions"].]

## [Section: e.g., Data Syncing]
[Flows for server interactions, e.g., "On save, client sends to [server] via [client]... Include verification steps. Assumptions: [e.g., "Assumes API uptime"]; Known Issues: [e.g., "Batch sync delays"].

Mermaid Diagram: [e.g., sequenceDiagram; Client->>Server: Send Data; Server->>Client: Confirm; Assumptions: [e.g., "Retry logic"]; Known Issues: [e.g., "Network partition"].]