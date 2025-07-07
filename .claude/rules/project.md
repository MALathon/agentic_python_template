# Project Rules and Guidelines

This document defines the coding standards, practices, and rules for this Python project.

## Code Attribution Rules

**IMPORTANT: When creating git commits:**
- DO NOT include Claude attribution in commit messages
- DO NOT add "Generated with Claude Code" or similar phrases
- DO NOT include "Co-Authored-By: Claude" or any AI attribution
- Commits should represent the human developer's work
- Keep commit messages professional and attribution-free

## Code Style and Standards

### Python Code Style
- Follow PEP 8 strictly
- Use Black for code formatting (line length: 88)
- Use isort for import sorting
- Use type hints for all function signatures
- Maximum line length: 88 characters
- Use descriptive variable and function names

### Naming Conventions
- **Variables**: lowercase_with_underscores
- **Constants**: UPPERCASE_WITH_UNDERSCORES
- **Classes**: PascalCase
- **Functions/Methods**: lowercase_with_underscores
- **Private methods**: _single_leading_underscore
- **Internal use only**: __double_leading_underscore

### Import Order
1. Standard library imports
2. Related third party imports
3. Local application/library specific imports
4. Separate each group with a blank line

### Documentation Standards

#### Docstrings
- Use Google-style docstrings
- All public modules, classes, functions must have docstrings
- Include type information in docstrings
- Document exceptions that may be raised

Example:
```python
def calculate_total(items: List[Item], tax_rate: float) -> float:
    """Calculate the total cost including tax.
    
    Args:
        items: List of items to calculate total for
        tax_rate: Tax rate as a decimal (e.g., 0.08 for 8%)
        
    Returns:
        Total cost including tax
        
    Raises:
        ValueError: If tax_rate is negative
    """
```

#### Comments
- Use comments sparingly; code should be self-documenting
- Comments should explain "why", not "what"
- Update comments when code changes
- No commented-out code in production

## Testing Requirements

### Test Coverage
- Minimum code coverage: 80%
- Target code coverage: 90%+
- All public APIs must have tests
- Test edge cases and error conditions

### Test Structure
- Use pytest as the testing framework
- Organize tests to mirror source code structure
- Use descriptive test names that explain what is being tested
- Follow AAA pattern: Arrange, Act, Assert

### Test Types
- **Unit Tests**: Required for all business logic
- **Integration Tests**: Required for API endpoints and database operations
- **End-to-End Tests**: For critical user workflows only

## Git Workflow

### Branch Naming
- Feature branches: `feature/description-of-feature`
- Bug fixes: `fix/description-of-bug`
- Hotfixes: `hotfix/description-of-issue`
- Release branches: `release/version-number`

### Commit Messages
- Use conventional commit format
- Start with type: feat, fix, docs, style, refactor, test, chore
- Keep subject line under 50 characters
- Use imperative mood ("Add feature" not "Added feature")
- Include body for complex changes
- Reference issue numbers when applicable

Example:
```
feat: add user authentication endpoint

- Implement JWT-based authentication
- Add login and logout endpoints
- Include refresh token functionality

Closes #123
```

## Code Review Standards

### Review Checklist
- [ ] Code follows style guidelines
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No security vulnerabilities
- [ ] Performance impact considered
- [ ] Error handling is appropriate

### Review Process
1. All code must be reviewed before merging
2. Address all feedback or discuss why not
3. Re-request review after significant changes
4. Reviewer approves when satisfied

## Security Guidelines

### General Security
- Never commit secrets or credentials
- Use environment variables for configuration
- Validate all user input
- Use parameterized queries for database operations
- Keep dependencies up to date

### Authentication & Authorization
- Use strong password hashing (bcrypt, argon2)
- Implement proper session management
- Use HTTPS for all communications
- Follow principle of least privilege

## Performance Guidelines

### Code Performance
- Profile before optimizing
- Optimize algorithms before micro-optimizations
- Use appropriate data structures
- Minimize database queries
- Implement caching where beneficial

### Database Performance
- Use indexes appropriately
- Avoid N+1 queries
- Use pagination for large datasets
- Monitor query performance

## Error Handling

### Exception Handling
- Catch specific exceptions, not generic Exception
- Log errors with appropriate context
- Don't silence exceptions without logging
- Create custom exceptions for domain-specific errors
- Always clean up resources (use context managers)

### Logging
- Use Python's logging module, not print statements
- Log at appropriate levels (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- Include relevant context in log messages
- Don't log sensitive information

## Dependency Management

### Adding Dependencies
- Justify each new dependency
- Check license compatibility
- Consider security implications
- Prefer well-maintained packages
- Pin versions in requirements.txt

### Updating Dependencies
- Regular updates for security patches
- Test thoroughly after updates
- Update one major dependency at a time
- Document breaking changes

## API Design

### RESTful Principles
- Use appropriate HTTP methods
- Return appropriate status codes
- Version APIs when needed
- Use consistent URL patterns
- Implement proper pagination

### API Documentation
- Document all endpoints
- Include request/response examples
- Document error responses
- Keep documentation synchronized with code

## Continuous Integration

### CI Requirements
- All tests must pass
- Code coverage must meet minimum
- Linting must pass (black, flake8, mypy)
- Security scanning must pass
- Documentation must build successfully

## Project Structure

### Directory Organization
```
project/
├── src/
│   ├── __init__.py
│   ├── models/
│   ├── services/
│   ├── api/
│   └── utils/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── docs/
├── scripts/
└── .claude/
```

### File Organization
- One class per file (generally)
- Group related functionality
- Keep files focused and small
- Use __init__.py for public APIs

## Development Workflow

### Before Starting Work
1. Pull latest changes from main
2. Create feature branch
3. Review related issues/requirements
4. Plan implementation approach

### During Development
1. Write tests first (TDD) when possible
2. Commit frequently with clear messages
3. Keep commits focused and atomic
4. Run tests locally before pushing

### Before Creating PR
1. Rebase on latest main
2. Run full test suite
3. Check code coverage
4. Update documentation
5. Self-review changes
6. Check all linters
7. Ensure linting, mypy, pylance etc. pass ci/cd before merge requests.

## Monitoring and Metrics

### Application Metrics
- Monitor response times
- Track error rates
- Monitor resource usage
- Set up appropriate alerts

### Code Quality Metrics
- Track test coverage trends
- Monitor code complexity
- Review dependency health
- Track technical debt

---

These rules ensure consistent, high-quality code across the project. All team members and agents should follow these guidelines.