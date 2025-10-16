# Server Structure Template

This document defines the server architecture, data models, and rules for [Project Name], ensuring scalable and secure data management.

## Guidelines for Filling Out This Template
- Replace [Project Name] with your project's name.
- For decentralized: Detail layers (e.g., client, DHT, blockchain); for traditional: DB schemas.
- Use diagrams (Mermaid ER) for data flows.
- Include validation rules (e.g., "Max [limit] entries").
- Adapt for tech: For [server: e.g., Holochain], add zome examples; for SQL, schemas.
- Reference repo structure: Store this in /docs/agents/server_structure_doc.md; link to /file_structure.md for server files in /source/[server-dir]/.

## Data Distribution and Hierarchy
[Client-Side: Structures like {memory: obj}; [Server Layer]: JSON entries; etc. Include Mermaid diagram. Assumptions: [e.g., "Local storage limits"]; Known Issues: [e.g., "Sync delays"].]

Mermaid Diagram: [e.g., erDiagram; CLIENT ||--|| SERVER : syncs; Assumptions: [e.g., "Batch updates"]; Known Issues: [e.g., "Conflict resolution"].]

## Authentication Logic
[Process: e.g., "[Auth method] sign-in"; Data Flow: "Key links to [storage]." Example: Code snippet for login. Assumptions: [e.g., "JWT expiry"]; Known Issues: [e.g., "Token revocation"].]

## Data Management Rules
[Client: "Temporary state"; Validation: "[Server] rules for integrity." Example: Schema or zome function. Assumptions: [e.g., "Batch sync"]; Known Issues: [e.g., "Conflict resolution"].]

## Edge Cases
[Network Disconnect: "Cache in [storage]"; etc. Include handling code. Assumptions: [e.g., "Offline tolerance"]; Known Issues: [e.g., "Re-sync failures"].]