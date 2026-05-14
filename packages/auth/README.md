# @legimi/auth

Production-grade authentication and authorization system for LEGIMI Commerce.

## Overview

This package provides:
- ✅ JWT-based authentication
- ✅ OAuth provider support (Google, GitHub, Apple)
- ✅ Password reset flows
- ✅ Role-based access control (RBAC)
- ✅ Session management
- ✅ Audit logging
- ✅ Rate limiting

## Installation

```bash
pnpm add @legimi/auth
```

## Quick Start

```typescript
import { AuthService } from '@legimi/auth'

const authService = new AuthService(database, config)

// Sign up
const user = await authService.signUp({
  email: 'user@example.com',
  password: 'secure-password',
})

// Sign in
const session = await authService.signIn({
  email: 'user@example.com',
  password: 'secure-password',
})

// Verify token
const payload = await authService.verifyToken(session.token)
```

## Architecture

### Components

1. **AuthService** — Main authentication service
2. **TokenService** — JWT token management
3. **OAuthProvider** — OAuth integration
4. **RBACManager** — Role-based access control
5. **AuditLogger** — Security audit logging

### Data Flow

```
User Input → Validation → Encryption → Database Store → Session Generation
                                          ↓
                                    Token Creation → Return to Client
```

## API Reference

### signUp
```typescript
async signUp(input: SignUpInput): Promise<AuthPayload>
```

### signIn
```typescript
async signIn(input: SignInInput): Promise<AuthPayload>
```

### refreshToken
```typescript
async refreshToken(refreshToken: string): Promise<AuthPayload>
```

### logout
```typescript
async logout(userId: string): Promise<void>
```

### verifyToken
```typescript
async verifyToken(token: string): Promise<TokenPayload>
```

## Configuration

```typescript
const config = {
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: '24h',
    refreshExpiresIn: '7d',
  },
  oauth: {
    google: {
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    },
    github: {
      clientId: process.env.GITHUB_CLIENT_ID,
      clientSecret: process.env.GITHUB_CLIENT_SECRET,
    },
  },
  bcrypt: {
    rounds: 12,
  },
}
```

## Testing

```bash
# Run tests
pnpm test

# Watch mode
pnpm test:watch

# Coverage
pnpm test:cov
```

## Security Considerations

- Passwords are hashed with bcrypt (12 rounds)
- JWT tokens are signed with HS256
- Refresh tokens stored securely (httpOnly cookies)
- Rate limiting on authentication endpoints
- All auth events are audited

## Environment Variables

```env
JWT_SECRET=your-secret-key
JWT_EXPIRATION=24h
JWT_REFRESH_SECRET=your-refresh-secret
JWT_REFRESH_EXPIRATION=7d

GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=
APPLE_CLIENT_ID=
APPLE_CLIENT_SECRET=
```

## Integration with NestJS

```typescript
import { Module } from '@nestjs/common'
import { AuthModule } from '@legimi/auth'

@Module({
  imports: [AuthModule],
  providers: [],
})
export class AppModule {}
```

## Integration with Next.js

```typescript
import { useAuth } from '@legimi/auth'

export const LoginPage = () => {
  const { login, loading } = useAuth()

  return (
    <form onSubmit={(e) => login(email, password)}>
      {/* form fields */}
    </form>
  )
}
```

## Performance

- Token verification: < 1ms
- Password hashing: ~100ms (bcrypt with 12 rounds)
- Database queries: < 50ms (with proper indexing)

## Roadmap

- [ ] Two-factor authentication
- [ ] Biometric authentication
- [ ] Social linking
- [ ] Session management UI
- [ ] Advanced audit logging

## Contributing

See [../DEVELOPMENT.md](../DEVELOPMENT.md) for contribution guidelines.

## License

PROPRIETARY — All rights reserved.
