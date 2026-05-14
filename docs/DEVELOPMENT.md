# DEVELOPMENT GUIDELINES

## Code Quality Standards

### TypeScript
- **Strict Mode**: Always enabled
- **No `any`**: Use explicit types
- **Interfaces > Types**: For extensibility
- **Enums**: For fixed option sets

### Naming Conventions

```typescript
// ✅ Good
const UserRoleMap: Record<string, UserRole> = { ... }
interface IUserService { ... }
const calculateTotalPrice = (items: OrderItem[]): number => { ... }

// ❌ Bad
const data = { ... }
type IUser = { ... } // Types shouldn't use I prefix
function x(a: any) { ... }
```

### File Organization

```
packages/auth/src/
├── index.ts                 # Public exports
├── types.ts                 # Type definitions
├── constants.ts             # Constants
├── errors.ts                # Custom errors
├── services/                # Business logic
│   ├── auth.service.ts
│   └── token.service.ts
├── providers/               # External integrations
│   ├── google.provider.ts
│   └── github.provider.ts
├── middleware/              # Express/NestJS middleware
│   └── auth.middleware.ts
├── utils/                   # Helpers
│   └── validators.ts
├── __tests__/               # Tests
│   └── auth.service.test.ts
└── README.md                # Documentation
```

### Component Architecture

```typescript
// ✅ Good - Modular, testable
interface SignUpFormProps {
  onSuccess: (user: User) => void
  loading?: boolean
}

const SignUpForm: React.FC<SignUpFormProps> = ({ onSuccess, loading = false }) => {
  const [form, setForm] = useForm(...)
  return (...)
}

// ❌ Bad - Tightly coupled
const SignUpForm = () => {
  // Makes API calls directly
  // Mutates global state
  // Hard to test
}
```

## Performance Guidelines

### Images
- Use `next/image` for optimization
- Lazy load below-the-fold
- Provide responsive srcset
- Use modern formats (WebP)

### Rendering
- Use React.memo for expensive components
- Lazy load routes with `next/dynamic`
- Code split by route
- Use virtual scrolling for long lists

### Database
- Index frequently queried columns
- Use connection pooling
- Implement caching (Redis)
- Monitor slow queries

### API
- Use DataLoader for batch queries
- Implement pagination
- Compress responses (gzip)
- Cache GET requests

## Animation Guidelines

### Principles
- Use Framer Motion for all animations
- Spring physics by default
- No animation > 500ms
- Respect `prefers-reduced-motion`

```typescript
// ✅ Good - Intentional, smooth
<motion.div
  initial={{ opacity: 0, y: 10 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ type: "spring", bounce: 0.3 }}
/>

// ❌ Bad - Generic, slow
<div style={{ animation: "fade 2s linear" }} />
```

## Testing Guidelines

### Unit Tests
```typescript
describe('calculateTotalPrice', () => {
  it('should sum all item prices', () => {
    const items = [
      { price: 10, quantity: 2 },
      { price: 5, quantity: 1 },
    ]
    expect(calculateTotalPrice(items)).toBe(25)
  })
})
```

### Integration Tests
```typescript
describe('AuthService', () => {
  let authService: AuthService
  let database: Database

  beforeAll(async () => {
    database = new Database()
    authService = new AuthService(database)
  })

  it('should create user and return token', async () => {
    const user = await authService.signUp({
      email: 'test@example.com',
      password: 'password123',
    })
    expect(user.email).toBe('test@example.com')
  })
})
```

## Commit Guidelines

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (no logic change)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

### Example
```
feat(auth): implement password reset flow

- Add password reset request endpoint
- Add email template for reset link
- Add token validation middleware
- Add tests for password update

Fixes #123
```

## Error Handling

### Backend Errors
```typescript
class UserNotFoundError extends AppError {
  constructor() {
    super('User not found', 404, 'USER_NOT_FOUND')
  }
}

// Use custom errors in services
throw new UserNotFoundError()
```

### Frontend Errors
```typescript
try {
  const response = await fetch(...)
} catch (error) {
  if (error instanceof NetworkError) {
    showToast('Network error, please try again')
  } else {
    showToast('Something went wrong')
  }
}
```

## Documentation Requirements

### For Every Package

```markdown
# Package Name

## Overview
Brief description of what this package does.

## Installation
\`\`\`bash
pnpm add @legimi/package-name
\`\`\`

## Usage
Code examples showing common use cases.

## API Reference
Detailed API documentation.

## Architecture Decisions
Why were certain choices made?

## Performance Considerations
Optimization notes and benchmarks.

## Testing
How to run tests for this package.
```

### For Every Component

```typescript
/**
 * Button Component
 * 
 * @example
 * ```tsx
 * <Button onClick={() => {}}>Click me</Button>
 * ```
 */
interface ButtonProps {
  /** Button text */
  children: React.ReactNode
  /** On click handler */
  onClick: () => void
  /** Button variant */
  variant?: 'primary' | 'secondary'
  /** Disabled state */
  disabled?: boolean
}

export const Button: React.FC<ButtonProps> = ({ ... }) => { ... }
```

## Review Checklist

Before submitting a PR:

- [ ] Code follows style guide
- [ ] TypeScript passes strict mode
- [ ] Tests added/updated
- [ ] Tests pass
- [ ] No console errors
- [ ] Performance considered
- [ ] Accessibility checked (a11y)
- [ ] Documentation updated
- [ ] Commit messages follow convention

## Local Development Checklist

### First Time Setup
```bash
# Clone and install
git clone ...
cd legimi-commerce
pnpm install

# Setup databases
docker-compose up -d

# Run migrations
pnpm db:migrate

# Start development
pnpm dev
```

### Before Starting Work
```bash
# Update dependencies
pnpm install

# Run type check
pnpm type-check

# Run linter
pnpm lint

# Run tests
pnpm test
```

### After Making Changes
```bash
# Format code
pnpm format

# Type check
pnpm type-check

# Run affected tests
pnpm test:changed

# Manual testing in browser
```
