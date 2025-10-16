# File Structure Template

This document outlines the file organization for [Project Name], ensuring modularity and maintainability across source, scripts, tests, and docs.

## Guidelines for Filling Out This Template
- Replace [Project Name] with your project's name.
- Customize directories for your stack (e.g., add `/source/[lang-dir]/` for Python/Rust).
- Use trees for visualization (Markdown code block).
- Include storage details (e.g., [storage: e.g., IndexedDB] for client).
- Adapt for languages: For Python, add `/source/api/`; for JS, `/source/client/`.
- Reference repo structure: This file defines the root layout; store it in /docs/agents/file_structure_doc.md.

## Standard Repo Layout (Mandatory)
All projects must follow this root structure to ensure cleanliness and agent cohesion. Deviations require explicit user approval.

```
root/
├── AGENTS.md                    # AI agent rules and context boundaries (program)
├── User_Rules_Template.md      # Platform tool bindings (Cursor/Kilo variants optional)
├── README.md                   # Project overview and quick start
├── .env.example               # Environment variables template
├── .gitignore                 # Git ignore patterns
├── package.json               # Dependencies and scripts (if applicable)
├── source/                    # Main application code
│   ├── client/               # Client-side code
│   │   ├── components/       # Reusable UI components
│   │   ├── pages/           # Page components/routes
│   │   ├── hooks/           # Custom React hooks (if applicable)
│   │   ├── utils/           # Client-side utilities
│   │   └── styles/          # CSS/styling files
│   └── server/              # Backend/server-side code
│       ├── routes/          # API routes/endpoints
│       ├── models/          # Data models/schemas
│       ├── middleware/      # Express middleware (if applicable)
│       ├── services/        # Business logic services
│       └── utils/           # Server-side utilities
├── scripts/                  # Build and deployment scripts
│   ├── setup.sh            # Initial project setup
│   ├── test-suite.sh       # Run all tests
│   ├── build.sh            # Build for production
│   └── deploy.sh           # Deployment script
├── tests/                   # Test suites
│   ├── unit/               # Unit tests
│   ├── integration/        # Integration tests
│   ├── e2e/               # End-to-end tests
│   ├── security/          # Security tests
│   └── performance/       # Performance tests
└── docs/                   # Documentation
    ├── agents/            # AI agent context documents
    ├── code/              # Code documentation
    ├── tests/             # Test documentation
    └── api/               # API documentation (if applicable)
```

**Assumptions**: Modular by layer, clear separation of concerns, AI-friendly structure
**Known Issues**: Cross-language dependencies may require additional configuration

## Client-Side Structure
**Root**: `/source/client/`
**Purpose**: Client application code, UI components, and client-side logic

```
source/client/
├── components/           # Reusable UI components
│   ├── Button.jsx      # Example: Reusable button component
│   ├── Modal.jsx       # Example: Modal dialog component
│   └── index.js        # Component exports
├── pages/              # Page components/routes
│   ├── Home.jsx        # Example: Home page component
│   ├── Login.jsx       # Example: Login page component
│   └── Dashboard.jsx   # Example: Dashboard page component
├── hooks/              # Custom React hooks (if using React)
│   ├── useAuth.js      # Example: Authentication hook
│   └── useApi.js       # Example: API data fetching hook
├── utils/              # Client-side utilities
│   ├── api.js          # API client functions
│   ├── validation.js   # Form validation utilities
│   └── storage.js      # Local storage utilities
├── styles/             # CSS/styling files
│   ├── globals.css     # Global styles
│   ├── components.css  # Component-specific styles
│   └── variables.css   # CSS custom properties
└── index.js            # Application entry point
```

**Browser Storage**: IndexedDB for offline data, localStorage for user preferences
**Assumptions**: Modern browser support (ES6+), responsive design
**Known Issues**: Browser compatibility, storage size limits

## Server-Side Structure
**Root**: `/source/server/`
**Purpose**: Backend API, business logic, and data management

```
source/server/
├── routes/             # API routes/endpoints
│   ├── auth.js        # Example: Authentication routes
│   ├── users.js       # Example: User management routes
│   └── index.js       # Route registration
├── models/            # Data models/schemas
│   ├── User.js        # Example: User data model
│   ├── Product.js     # Example: Product data model
│   └── index.js       # Model exports
├── middleware/        # Express middleware (if using Express)
│   ├── auth.js        # Example: Authentication middleware
│   ├── validation.js  # Example: Request validation
│   └── errorHandler.js # Example: Error handling middleware
├── services/          # Business logic services
│   ├── authService.js # Example: Authentication service
│   ├── emailService.js # Example: Email service
│   └── paymentService.js # Example: Payment processing
├── utils/             # Server-side utilities
│   ├── database.js    # Database connection utilities
│   ├── encryption.js  # Encryption/decryption utilities
│   └── logger.js      # Logging utilities
└── app.js             # Application entry point
```

**Database**: PostgreSQL/MySQL for persistent data, Redis for caching
**Assumptions**: RESTful API design, stateless architecture
**Known Issues**: Database connection pooling, memory management

## Scripts and Automation
**Root**: `/scripts/`
**Purpose**: Build, test, and deployment automation

```
scripts/
├── setup.sh           # Initial project setup
│   # Install dependencies, setup environment
├── test-suite.sh      # Run all tests
│   # Unit → Integration → E2E → Security tests
├── build.sh           # Build for production
│   # Compile, bundle, optimize assets
├── deploy.sh          # Deployment script
│   # Deploy to staging/production
└── lint.sh            # Code quality checks
    # ESLint, Prettier, security scans
```

## Documentation Structure
**Root**: `/docs/`
**Purpose**: Comprehensive project documentation

```
docs/
├── agents/            # AI agent context documents
│   ├── project_requirements_doc.md
│   ├── app_flow_doc.md
│   ├── tech_stack_doc.md
│   ├── client_guidelines.md
│   ├── server_structure_doc.md
│   ├── implementation_plan.md
│   ├── file_structure_doc.md
│   ├── testing_guidelines.md
│   └── documentation_guidelines.md
├── code/              # Auto-generated code documentation
│   ├── client/        # Client-side module docs
│   ├── server/        # Server-side module docs
│   └── shared/        # Shared utilities docs
├── tests/             # Test documentation
│   ├── unit.md        # Unit test coverage and examples
│   ├── integration.md # Integration test scenarios
│   ├── e2e.md         # End-to-end test flows
│   └── security.md    # Security test results
└── api/               # API documentation (if applicable)
    ├── openapi.yaml   # OpenAPI specification
    └── endpoints.md   # Endpoint documentation
```

## Configuration and Environment
**Root Files**: Project configuration and environment setup (memory-aware)

- **`.env.example`**: Template for environment variables (API keys, database URLs)
- **`.gitignore`**: Git ignore patterns for secrets, build artifacts, dependencies
- **`package.json`**: Dependencies, scripts, and project metadata
- **`User_Rules_Cursor_Template.md` / `User_Rules_KiloCode_Template.md`**: Platform-specific user rules for memory + indexing + todos
- **`README.md`**: Project overview, setup instructions, and AGENTS.md reference

## Interoperability and Data Flow
**Client ↔ Server**: RESTful API communication, WebSocket for real-time updates
**Storage Strategy**: Client-side caching with server-side persistence
**Update Policy**: Incremental updates, conflict resolution, offline support
**Assumptions**: Modern web standards, HTTPS for security, responsive design
**Known Issues**: Network latency, offline synchronization, cross-browser compatibility