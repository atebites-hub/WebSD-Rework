# Documentation Guidelines Template

This document defines documentation practices for [Project Name], ensuring code maintainability and AI agent comprehension. Documentation serves as the living knowledge base for the project.

## Guidelines for Filling Out This Template
- Replace [Project Name] with your project's name.
- Choose documentation tools that integrate with your development environment (JSDoc, Sphinx, rustdoc).
- Set up automated documentation generation where possible.
- Establish documentation review processes and quality metrics.
- Reference repo structure: Store this in /docs/agents/documentation_guidelines.md; link to /file_structure.md for doc locations in /docs/.

## Documentation Structure
- **/docs/agents/**: Context boundary documents (AI agent knowledge base)
  - Files: project_requirements_doc.md, app_flow_doc.md, tech_stack_doc.md, client_guidelines.md, server_structure_doc.md, implementation_plan.md, file_structure_doc.md, testing_guidelines.md, this file.
- **/docs/code/**: Per-module documentation with Mermaid diagrams and API references
  - Integration with [tool: JSDoc/Sphinx/rustdoc] for automated generation
- **/docs/tests/**: Test documentation and coverage reports
  - Files: unit.md, security.md, integration.md, performance.md
- **/docs/api/**: API documentation (if applicable)
  - OpenAPI/Swagger specs, endpoint documentation

## Code Documentation Standards

### Docstring Format
Use language-specific standards that integrate with documentation tools:

**JavaScript/TypeScript (JSDoc)**:
```javascript
/**
 * [Brief description of function purpose]
 * @param {type} param - Parameter description
 * @returns {type} Return value description
 * @throws {ErrorType} When error occurs
 * @example
 * const result = functionName(input);
 */
function functionName(param) {
  // Implementation
}
```

**Python (Google Style)**:
```python
def function_name(param: type) -> return_type:
    """[Brief description of function purpose]
    
    Args:
        param: Parameter description
        
    Returns:
        Return value description
        
    Raises:
        ErrorType: When error occurs
        
    Example:
        >>> result = function_name(input)
    """
    # Implementation
```

### Automated Generation Setup
- **JavaScript**: `npm install --save-dev jsdoc`
- **Python**: `pip install sphinx sphinx-autodoc-typehints`
- **Rust**: Built-in with `cargo doc`

### Module Documentation Template
Each `/docs/code/[module].md` should include:
- Overview and purpose
- Mermaid architecture diagram
- API reference table
- Usage examples
- Dependencies and testing info

### Quality Gates
- **Coverage**: [X]% of public functions documented
- **Freshness**: Documentation updated within [timeframe] of code changes
- **Accuracy**: No broken links or outdated examples
- **Completeness**: All modules have corresponding documentation files