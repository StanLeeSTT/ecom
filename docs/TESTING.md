# 🧪 LEGIMI COMMERCE TEST SUITE

## Running Tests

### Unit Tests
```bash
pnpm test
```

### Integration Tests
```bash
pnpm test:integration
```

### E2E Tests
```bash
pnpm test:e2e
```

### Security Checks
```bash
bash scripts/security-check.sh
```

---

## ✅ Test Coverage

### Authentication Tests
- [ ] User signup
- [ ] User login
- [ ] Token refresh
- [ ] Password reset
- [ ] OAuth integration (Google, GitHub, Apple)

### API Tests
- [ ] GraphQL queries
- [ ] GraphQL mutations
- [ ] Error handling
- [ ] Rate limiting
- [ ] CORS validation

### Frontend Tests
- [ ] Dashboard loading
- [ ] Storefront loading
- [ ] Component rendering
- [ ] Form validation
- [ ] API integration

### Security Tests
- [ ] CORS headers
- [ ] Security headers
- [ ] Input validation
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] CSRF protection

---

## 🐛 Debug Commands

### Development
```bash
# Start with debug logging
DEBUG=* pnpm dev

# Watch mode
pnpm dev:watch

# Check for errors
pnpm type-check
```

### Production
```bash
# Run production build
pnpm build

# Start production server
pnpm start

# Check security
bash scripts/security-check.sh
```

### Debugging Specific Issues
```bash
# Check API
curl http://localhost:3001/api/health

# Check GraphQL
curl -X POST http://localhost:3001/api/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{__typename}"}'

# View logs
tail -f logs/application.log
```

---

## 📊 Performance Benchmarks

### Load Times (Development)
- Frontend: < 2s
- API: < 500ms
- Database: < 100ms

### Production Targets
- Frontend: < 1s (Vercel CDN)
- API: < 200ms (Railway)
- Database: < 50ms (Supabase)

---

## 🔍 Debugging Checklist

- [ ] TypeScript compilation passes
- [ ] No runtime errors
- [ ] All imports resolve
- [ ] Environment variables set
- [ ] Database connected
- [ ] APIs responding
- [ ] Logging working
- [ ] Security headers present

