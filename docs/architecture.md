# Architecture Overview

This document describes the high-level architecture of projects built using this template.

## Design Principles

### Separation of Concerns
- **Models**: Domain objects and data structures
- **Services**: Business logic and operations
- **API**: External interfaces and endpoints
- **Utils**: Shared utilities and helpers

### Clean Architecture
```
┌─────────────────────────────────────────┐
│             API Layer                   │
│         (Controllers/Routes)            │
├─────────────────────────────────────────┤
│           Service Layer                 │
│         (Business Logic)                │
├─────────────────────────────────────────┤
│            Model Layer                  │
│         (Domain Objects)                │
├─────────────────────────────────────────┤
│           Data Layer                    │
│    (Repositories/Database Access)       │
└─────────────────────────────────────────┘
```

## Directory Structure

### `/src`
The main source code directory organized by concern:

- **`/models`**: Domain models and entities
- **`/services`**: Business logic and use cases
- **`/api`**: REST endpoints, GraphQL schemas, CLI commands
- **`/utils`**: Shared utilities, helpers, and constants

### `/tests`
Test organization mirrors source structure:

- **`/unit`**: Isolated component tests
- **`/integration`**: Component interaction tests
- **`/e2e`**: Full workflow tests

### `/.claude`
Agent-specific configurations:

- **`/commands`**: Agent role definitions
- **`/rules`**: Project standards and guidelines
- **`/tasks`**: Task tracking and management

## Design Patterns

### Repository Pattern
Separate data access from business logic:

```python
class UserRepository:
    def find_by_id(self, user_id: int) -> Optional[User]:
        # Database access logic
        pass

class UserService:
    def __init__(self, repository: UserRepository):
        self.repository = repository
    
    def get_user(self, user_id: int) -> User:
        # Business logic
        user = self.repository.find_by_id(user_id)
        if not user:
            raise NotFoundError()
        return user
```

### Dependency Injection
Inject dependencies for testability:

```python
# In production
user_repo = UserRepository(db_connection)
user_service = UserService(user_repo)

# In tests
mock_repo = Mock(spec=UserRepository)
user_service = UserService(mock_repo)
```

### Service Layer Pattern
Encapsulate business logic in services:

```python
class OrderService:
    def __init__(self, order_repo, payment_service, notification_service):
        self.order_repo = order_repo
        self.payment_service = payment_service
        self.notification_service = notification_service
    
    def place_order(self, order_data: OrderData) -> Order:
        # Complex business logic coordinating multiple services
        pass
```

## API Design

### RESTful Endpoints
Follow REST conventions:

```
GET    /api/users          # List users
POST   /api/users          # Create user
GET    /api/users/{id}     # Get user
PUT    /api/users/{id}     # Update user
DELETE /api/users/{id}     # Delete user
```

### Request/Response Format
Consistent JSON structure:

```json
// Success Response
{
    "status": "success",
    "data": {
        "id": 1,
        "name": "John Doe"
    }
}

// Error Response
{
    "status": "error",
    "error": {
        "code": "VALIDATION_ERROR",
        "message": "Invalid email format",
        "details": {...}
    }
}
```

## Error Handling

### Custom Exceptions
Domain-specific exceptions:

```python
class DomainError(Exception):
    """Base exception for domain errors"""
    pass

class ValidationError(DomainError):
    """Validation failed"""
    pass

class NotFoundError(DomainError):
    """Resource not found"""
    pass

class BusinessRuleError(DomainError):
    """Business rule violation"""
    pass
```

### Error Propagation
Let errors bubble up to appropriate handlers:

```python
# Service layer
def transfer_funds(self, from_account, to_account, amount):
    if from_account.balance < amount:
        raise BusinessRuleError("Insufficient funds")
    # ... transfer logic

# API layer
@app.route('/transfer', methods=['POST'])
def transfer():
    try:
        result = service.transfer_funds(...)
        return jsonify({"status": "success", "data": result})
    except BusinessRuleError as e:
        return jsonify({"status": "error", "error": str(e)}), 400
```

## Testing Strategy

### Test Pyramid
- **Many Unit Tests**: Fast, isolated, comprehensive
- **Some Integration Tests**: Component interactions
- **Few E2E Tests**: Critical user journeys

### Test Organization
```
tests/
├── unit/
│   ├── models/
│   │   └── test_user.py
│   └── services/
│       └── test_user_service.py
├── integration/
│   └── test_api_endpoints.py
└── e2e/
    └── test_user_workflow.py
```

## Security Considerations

### Input Validation
Always validate at boundaries:
- API input validation
- Service layer validation
- Database constraints

### Authentication & Authorization
- Use established libraries (e.g., JWT)
- Implement proper session management
- Follow principle of least privilege

### Data Protection
- Encrypt sensitive data
- Use parameterized queries
- Implement rate limiting
- Log security events

## Performance Guidelines

### Caching Strategy
- Cache expensive computations
- Use appropriate cache invalidation
- Consider cache levels (memory, Redis, CDN)

### Database Optimization
- Use indexes appropriately
- Implement pagination
- Avoid N+1 queries
- Use connection pooling

### Async Operations
- Use async/await for I/O operations
- Implement background tasks
- Consider message queues for heavy processing

## Deployment Considerations

### Environment Configuration
- Use environment variables
- Separate configs by environment
- Never commit secrets

### Monitoring
- Application metrics
- Error tracking
- Performance monitoring
- Security auditing

### Scalability
- Stateless services
- Horizontal scaling ready
- Load balancing support
- Database replication