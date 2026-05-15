#!/bin/bash

# ============================================
# LEGIMI COMMERCE PERFORMANCE CHECK SCRIPT
# ============================================

set -e

echo "⚡ LEGIMI COMMERCE PERFORMANCE CHECK"
echo "===================================="
echo ""

# Check 1: Docker memory usage
echo "✓ Checking Docker memory usage..."
if command -v docker &> /dev/null; then
  DOCKER_MEMORY=$(docker stats --no-stream 2>/dev/null | tail -n +2 | awk '{print $7}' | grep -oE '[0-9]+' | awk '{s+=$1} END {print s}')
  if [ ! -z "$DOCKER_MEMORY" ]; then
    echo "  📊 Docker containers using: ${DOCKER_MEMORY}MB"
    if [ "$DOCKER_MEMORY" -gt 2000 ]; then
      echo "  ⚠️  WARNING: High Docker memory usage (>2GB)"
    else
      echo "  ✅ Docker memory usage acceptable"
    fi
  fi
else
  echo "  ℹ️  Docker not running"
fi

# Check 2: Response compression
echo "✓ Checking response compression..."
if grep -q "compression" apps/api/package.json; then
  echo "  ✅ Compression middleware installed"
else
  echo "  ❌ Compression middleware not found"
fi

# Check 3: GraphQL query limits
echo "✓ Checking GraphQL security..."
if grep -q "getQueryDepth" apps/api/src/app.module.ts; then
  echo "  ✅ Query depth limiting enabled"
else
  echo "  ⚠️  Query depth limiting not configured"
fi

# Check 4: Database connection pooling
echo "✓ Checking database configuration..."
if [ -f "apps/api/src/database/data-source.ts" ]; then
  if grep -q "poolSize\|pool:" apps/api/src/database/data-source.ts; then
    echo "  ✅ Database connection pooling configured"
  else
    echo "  ⚠️  Consider enabling connection pooling"
  fi
else
  echo "  ℹ️  Database not yet configured"
fi

# Check 5: Redis caching
echo "✓ Checking Redis configuration..."
if grep -q "REDIS_URL\|ioredis" apps/api/package.json; then
  echo "  ✅ Redis support available"
else
  echo "  ⚠️  Redis not configured"
fi

# Check 6: Build optimization
echo "✓ Checking build configuration..."
if [ -f "tsconfig.json" ]; then
  if grep -q "incremental" tsconfig.json; then
    echo "  ✅ Incremental builds enabled"
  else
    echo "  ℹ️  Consider enabling incremental builds"
  fi
else
  echo "  ⚠️  TypeScript config not found"
fi

# Check 7: Docker Compose
echo "✓ Checking Docker Compose..."
RUNNING_SERVICES=$(docker-compose ps 2>/dev/null | grep -c "Up" || echo "0")
if [ "$RUNNING_SERVICES" -gt 0 ]; then
  echo "  ✅ $RUNNING_SERVICES Docker services running"
else
  echo "  ℹ️  No Docker services running"
fi

# Check 8: API Response times (if running)
if curl -s http://localhost:3001/api/health &>/dev/null; then
  echo "✓ Checking API response times..."
  RESPONSE_TIME=$( { time curl -s http://localhost:3001/api/health > /dev/null; } 2>&1 | grep real | awk '{print $2}')
  echo "  📊 API response time: $RESPONSE_TIME"
fi

echo ""
echo "===================================="
echo "✅ Performance check complete!"
echo ""
echo "Tips for better performance:"
echo "1. Use 'pnpm dev:api' to start only the API"
echo "2. Enable Docker optional services only when needed"
echo "3. Monitor response times with: curl -w '@curl-format.txt' http://localhost:3001"
echo "4. Review PERFORMANCE_OPTIMIZATION.md for detailed guidance"
