# Testing Guidelines Template

This document outlines testing strategies for [Project Name], ensuring code integrity, security, and full-system functionality. Tests serve as the safety net for confident development and deployment.

## Guidelines for Filling Out This Template
- Replace [Project Name] with your project's name.
- Choose testing frameworks that integrate with your development environment and CI/CD pipeline.
- Set up automated test generation where possible.
- Establish test coverage thresholds and quality gates.
- Reference repo structure: Store this in /docs/agents/testing_guidelines.md; link to /file_structure.md for test locations in /tests/.

## Test Types and Tools

**Unit Tests** (`/tests/unit/`): Test individual functions/modules in isolation
- **JavaScript/TypeScript**: Jest + Testing Library
- **Python**: pytest + pytest-cov
- **Rust**: Built-in `cargo test`

**Integration Tests** (`/tests/integration/`): Test component interactions and data flow
- **API Testing**: Supertest (Node.js), requests (Python), reqwest (Rust)
- **Database Testing**: Testcontainers for isolated DB instances

**End-to-End Tests** (`/tests/e2e/`): Test complete user workflows
- **Web Applications**: Playwright or Cypress
- **Mobile Apps**: Detox (React Native) or Appium

**Security Tests** (`/tests/security/`): Identify vulnerabilities and security misconfigurations
- **Static Analysis**: ESLint-plugin-security, bandit (Python), cargo-audit (Rust)
- **Dependency Scanning**: npm audit, safety (Python), cargo audit

**Performance Tests** (`/tests/performance/`): Ensure performance requirements are met
- **Load Testing**: Artillery, k6, or JMeter
- **Memory Profiling**: Clinic.js (Node.js), memory_profiler (Python)

## Setup and Configuration

### Installation Commands
- **JavaScript/TypeScript**: `npm install --save-dev jest @testing-library/react playwright eslint-plugin-security`
- **Python**: `pip install pytest pytest-cov bandit safety`
- **Rust**: Built-in with cargo, add dev-dependencies to Cargo.toml

### Configuration Files
- **Jest**: `jest.config.js` with coverage thresholds and test environment setup
- **Playwright**: `playwright.config.js` with browser configurations and timeouts
- **pytest**: `pytest.ini` or `pyproject.toml` with test discovery and coverage settings

## Test Execution

### Local Development
- **All Tests**: `npm run test` or `pytest` or `cargo test`
- **Specific Types**: `npm run test:unit`, `npm run test:e2e`, etc.
- **Coverage**: `npm run test:coverage` with [X]% threshold requirement
- **Watch Mode**: `npm run test:watch` for development

### CI/CD Integration
- **GitHub Actions**: Automated test runs on push/PR
- **Coverage Reports**: Integration with Codecov or similar
- **Security Scans**: Automated vulnerability checks

## Quality Gates

### Coverage Requirements
- **Unit Tests**: Minimum [X]% line coverage
- **Integration Tests**: All critical paths covered
- **E2E Tests**: All user journeys tested
- **Security Tests**: Zero high/critical vulnerabilities

### Performance Benchmarks
- **API Response Time**: < [X]ms for 95th percentile
- **Page Load Time**: < [X] seconds for initial load
- **Memory Usage**: No memory leaks detected
- **Database Queries**: < [X]ms average response time

### Test Maintenance
- **Daily**: Run unit tests on every commit
- **Sprint Reviews**: Ensure coverage targets met
- **Monthly**: Review and update test data and fixtures