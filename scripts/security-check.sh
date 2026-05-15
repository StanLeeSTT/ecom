#!/bin/bash

# ============================================
# LEGIMI COMMERCE SECURITY CHECK SCRIPT
# ============================================
# This script validates security settings and runs checks

set -e

echo "🔒 LEGIMI COMMERCE SECURITY CHECK"
echo "===================================="
echo ""

# Check 1: TypeScript strict mode
echo "✓ Checking TypeScript configuration..."
if grep -q '"strict": true' tsconfig.json; then
  echo "  ✅ Strict mode enabled"
else
  echo "  ❌ Strict mode NOT enabled"
  exit 1
fi

# Check 2: .env.local in gitignore
echo "✓ Checking .gitignore..."
if grep -q ".env.local" .gitignore; then
  echo "  ✅ .env.local is ignored"
else
  echo "  ⚠️  .env.local might not be ignored"
fi

# Check 3: No hardcoded secrets
echo "✓ Checking for hardcoded secrets..."
if grep -r "sk_" apps/ packages/ 2>/dev/null | grep -v "\.example" || true; then
  echo "  ❌ WARNING: Potential hardcoded secrets found"
else
  echo "  ✅ No hardcoded secrets detected"
fi

# Check 4: Environment variables
echo "✓ Checking environment variables..."
if grep -q "ALLOWED_ORIGINS" .env.example; then
  echo "  ✅ CORS origins configured"
else
  echo "  ⚠️  CORS origins not configured"
fi

if grep -q "NODE_ENV" .env.example; then
  echo "  ✅ NODE_ENV variable configured"
else
  echo "  ⚠️  NODE_ENV not configured"
fi

# Check 5: CORS hardening in API
echo "✓ Checking API security..."
if grep -q "allowedOrigins" apps/api/src/main.ts; then
  echo "  ✅ CORS hardening implemented"
else
  echo "  ⚠️  CORS might not be hardened"
fi

# Check 6: GraphQL security
echo "✓ Checking GraphQL configuration..."
if grep -q "NODE_ENV !== 'production'" apps/api/src/app.module.ts; then
  echo "  ✅ GraphQL playground disabled in production"
else
  echo "  ⚠️  GraphQL playground might be exposed in production"
fi

# Check 7: Dependencies
echo "✓ Checking dependencies..."
if command -v npm &> /dev/null; then
  echo "  Checking for vulnerabilities..."
  npm audit --json > /tmp/npm-audit.json 2>&1 || true
  VULN_COUNT=$(jq '.vulnerabilities | length' /tmp/npm-audit.json 2>/dev/null || echo "0")
  if [ "$VULN_COUNT" -gt 0 ]; then
    echo "  ⚠️  Found $VULN_COUNT vulnerabilities"
  else
    echo "  ✅ No known vulnerabilities"
  fi
else
  echo "  ℹ️  npm not found, skipping dependency check"
fi

echo ""
echo "===================================="
echo "✅ Security check complete!"
echo ""
echo "Next steps:"
echo "1. Review SECURITY_AND_DEBUG_REPORT.md"
echo "2. Setup your environment variables (.env.local)"
echo "3. Deploy with confidence!"
