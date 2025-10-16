# Client Guidelines Template

This document provides design and coding standards for the client of [Project Name], ensuring consistent UI/UX and maintainable code.

## Guidelines for Filling Out This Template
- Replace [Project Name] with your project's name.
- Customize palette/spacing to your theme (e.g., add hex codes for colors).
- For mobile-first: Include responsive rules (e.g., media queries).
- Use examples in code blocks (e.g., CSS snippets).
- Adapt for frameworks: If vanilla JS, focus on [element: e.g., Canvas]; if React, add component rules.
- Reference repo structure: Store this in /docs/agents/client_guidelines.md; link to /file_structure.md for UI files in /source/client/.

## Fonts
[Primary: Name/size; Fallback: Name; Usage: e.g., "For UI text, scale to [size] on mobile." Example: CSS @import url('font-url'); Assumptions: [e.g., "Web-safe"]; Known Issues: [e.g., "Slow load on mobile"].]

## Color Palette
[Black (#000000): Background; White (#FFFFFF): Text; etc. Example: :root { --primary: #000; } Assumptions: [e.g., "Dark mode support"]; Known Issues: [e.g., "Color blindness accessibility"].]

## Spacing & Layout Rules
[Canvas/[UI Element]: Full-screen; Viewport: [dimensions]; etc. Example: .container { padding: 20px; } Assumptions: [e.g., "Responsive breakpoints"]; Known Issues: [e.g., "Overflow on small screens"].]

## Preferred UI Library or Framework
[Choice: [e.g., Vanilla JS]; Reason: Simplicity; Usage: e.g., "[Element] for rendering." Example: No deps needed. Assumptions: [e.g., "Browser APIs"]; Known Issues: [e.g., "Limited animations"].]

## Icon Set
[Custom: Size/style; Source: e.g., "From /source/assets"; Usage: "Draw on [element]." Example: <img src="icon.svg"> Assumptions: [e.g., "SVG for scalability"]; Known Issues: [e.g., "Fallback for no-support browsers"].]