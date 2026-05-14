#!/bin/bash

# LEGIMI COMMERCE — COMPLETE SETUP SCRIPT
# This script guides you through complete setup with free AI, Supabase, and GitHub deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    LEGIMI COMMERCE — COMPLETE SETUP WIZARD                 ║${NC}"
echo -e "${BLUE}║    AI-Native Commerce Operating System                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to print step
print_step() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# ============================================================
# STEP 1: CHECK PREREQUISITES
# ============================================================
print_step "Checking prerequisites..."

check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 is not installed"
        echo "  Install from: $2"
        return 1
    fi
    print_success "$1 is installed"
    return 0
}

check_command "node" "https://nodejs.org/"
check_command "pnpm" "npm install -g pnpm"
check_command "git" "https://git-scm.com/"
check_command "docker" "https://www.docker.com/"

echo ""

# ============================================================
# STEP 2: INITIALIZE REPOSITORY
# ============================================================
print_step "Initializing Git repository..."

if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "Initial commit: LEGIMI Commerce monorepo setup"
    print_success "Git repository initialized"
else
    print_success "Git repository already initialized"
fi

echo ""

# ============================================================
# STEP 3: SETUP ENVIRONMENT
# ============================================================
print_step "Setting up environment variables..."

if [ ! -f ".env.local" ]; then
    cp .env.example .env.local
    print_success "Created .env.local from template"
    echo -e "${YELLOW}  ⚠️  Edit .env.local with your actual API keys${NC}"
else
    print_success ".env.local already exists"
fi

echo ""

# ============================================================
# STEP 4: INSTALL DEPENDENCIES
# ============================================================
print_step "Installing dependencies..."
pnpm install
print_success "Dependencies installed"

echo ""

# ============================================================
# STEP 5: START DEVELOPMENT SERVICES
# ============================================================
print_step "Starting Docker services..."

if command -v docker-compose &> /dev/null; then
    docker-compose up -d
    print_success "Docker services started"
    echo ""
    echo -e "${YELLOW}Services running:${NC}"
    echo "  • PostgreSQL: localhost:5432"
    echo "  • Redis: localhost:6379"
    echo "  • OpenSearch: localhost:9200"
    echo "  • MinIO: localhost:9000 (console at :9001)"
else
    print_error "Docker not running. Start it manually:"
    echo "  docker-compose up -d"
fi

echo ""

# ============================================================
# STEP 6: INTERACTIVE SETUP
# ============================================================
echo -e "${YELLOW}Would you like to setup free AI services? (y/n)${NC}"
read -r ai_setup

if [ "$ai_setup" = "y" ] || [ "$ai_setup" = "Y" ]; then
    echo ""
    echo -e "${BLUE}Free AI Services Setup:${NC}"
    echo ""
    echo "1. GROQ (Fastest free LLM)"
    echo "   → Go to: https://console.groq.com/keys"
    echo "   → Get API key and add to .env.local"
    echo ""
    echo "2. Hugging Face (Image generation, text)"
    echo "   → Go to: https://huggingface.co/settings/tokens"
    echo "   → Create token and add to .env.local"
    echo ""
    echo "3. Ollama (Local LLM - optional)"
    echo "   → Download from: https://ollama.ai"
    echo "   → Run: ollama pull mistral"
    echo ""
    echo -e "${YELLOW}Press Enter when you've added the keys to .env.local${NC}"
    read
    print_success "AI services configured"
fi

echo ""

# ============================================================
# STEP 7: SUPABASE SETUP
# ============================================================
echo -e "${YELLOW}Would you like to setup Supabase? (y/n)${NC}"
read -r supabase_setup

if [ "$supabase_setup" = "y" ] || [ "$supabase_setup" = "Y" ]; then
    echo ""
    echo -e "${BLUE}Supabase Setup:${NC}"
    echo ""
    echo "1. Go to: https://app.supabase.com"
    echo "2. Create new project"
    echo "3. Get your credentials:"
    echo "   • Project URL"
    echo "   • Anon Key"
    echo "   • Service Role Key"
    echo ""
    echo "4. Add to .env.local:"
    echo "   SUPABASE_URL=your_url"
    echo "   SUPABASE_ANON_KEY=your_anon_key"
    echo "   SUPABASE_SERVICE_KEY=your_service_key"
    echo ""
    echo -e "${YELLOW}Press Enter when Supabase is configured${NC}"
    read
    print_success "Supabase configured"
fi

echo ""

# ============================================================
# STEP 8: GITHUB SETUP
# ============================================================
echo -e "${YELLOW}Would you like to setup GitHub repository? (y/n)${NC}"
read -r github_setup

if [ "$github_setup" = "y" ] || [ "$github_setup" = "Y" ]; then
    echo ""
    echo -e "${BLUE}GitHub Setup:${NC}"
    echo ""
    echo "1. Go to: https://github.com/new"
    echo "2. Create repository: legimi-commerce"
    echo "3. Choose: Public (recommended)"
    echo ""
    echo "4. Copy the repository URL"
    echo ""
    echo -e "${YELLOW}Enter your GitHub repository URL:${NC}"
    read -r github_url
    
    if [ ! -z "$github_url" ]; then
        git remote add origin "$github_url" 2>/dev/null || git remote set-url origin "$github_url"
        git branch -M main 2>/dev/null || true
        print_success "GitHub remote configured"
        print_success "Ready to push: git push -u origin main"
    fi
fi

echo ""

# ============================================================
# STEP 9: DEVELOPMENT SERVERS
# ============================================================
print_step "Ready to start development servers"

echo ""
echo -e "${BLUE}To start development in separate terminals:${NC}"
echo ""
echo "Terminal 1 - API Server:"
echo -e "  ${YELLOW}cd apps/api && pnpm dev${NC}"
echo ""
echo "Terminal 2 - Dashboard:"
echo -e "  ${YELLOW}cd apps/web && pnpm dev${NC}"
echo ""
echo "Terminal 3 - Storefront:"
echo -e "  ${YELLOW}cd apps/storefront && pnpm dev${NC}"
echo ""

# ============================================================
# STEP 10: DISPLAY SUMMARY
# ============================================================
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ SETUP COMPLETE!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Edit .env.local with your API keys"
echo "2. Run the development servers (see above)"
echo "3. Visit http://localhost:3000 (dashboard)"
echo "4. Visit http://localhost:3002 (storefront)"
echo ""
echo -e "${YELLOW}Documentation:${NC}"
echo "  • Quick Start: docs/GETTING_STARTED.md"
echo "  • Architecture: docs/ARCHITECTURE.md"
echo "  • Free AI Guide: docs/FREE_AI_INTEGRATION.md"
echo "  • Supabase Setup: docs/SUPABASE_SETUP.md"
echo "  • Deployment: docs/GITHUB_DEPLOYMENT.md"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo "  pnpm dev         — Start all services"
echo "  pnpm type-check  — Check TypeScript"
echo "  pnpm lint        — Lint code"
echo "  pnpm test        — Run tests"
echo "  git push         — Push to GitHub"
echo ""
echo -e "${BLUE}Happy coding! 🚀${NC}"
