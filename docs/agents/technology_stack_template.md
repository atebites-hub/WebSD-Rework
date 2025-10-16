# Technology Stack Template

This document lists the technologies, packages, dependencies, APIs, and tools for [Project Name], with purposes and documentation links to guide implementation.

## Guidelines for Filling Out This Template
- Replace [Project Name] with your project's name.
- Use tables for packages/tools (columns: Package, Purpose, Docs).
- Categorize by layer (front-end, back-end, tools) for clarity.
- Include installation notes (e.g., "npm install X") and version pins (e.g., "^1.0.0").
- For multi-lang projects: Separate by language (e.g., JS vs. Python sections).
- Update for changes: Add new entries, note deprecations.
- Reference repo structure: Store this in /docs/agents/tech_stack_doc.md; link to /file_structure.md for dep locations in /source/.

## Front-End
[Table: e.g., | HTML5 Canvas | Rendering [element] | [MDN Docs](link) | Installation: Native browser API. Assumptions: [e.g., "Browser support ES6+"]; Known Issues: [e.g., "IE11 incompatibility"].]

## Back-End
[Table: e.g., | [Backend: e.g., Holochain hClient] | [Purpose] | [Docs](link) | Installation: npm install X. Assumptions: [e.g., "Local conductor"]; Known Issues: [e.g., "Beta mobile support"].]

## Data Storage
[Table: e.g., | IndexedDB | Client caching | [MDN Docs](link) | Usage: For offline assets. Assumptions: [e.g., "5MB limit"]; Known Issues: [e.g., "Private browsing clears data"].]

## Development Tools
[Table: e.g., | npm | Package management | [Docs](link) | Installation: With Node.js. Assumptions: [e.g., "v18+"]; Known Issues: [e.g., "Lockfile conflicts"].]