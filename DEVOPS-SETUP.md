# Deccan Car Rental - DevOps Setup Guide

## 🏗️ Local Development Environment

### Prerequisites
```bash
# Required tools
- Node.js v18+ (use nvm for version management)
- Yarn 1.22.22+
- Docker Desktop
- Git
- VS Code (recommended)
```

### Initial Setup

#### 1. Clone Repository
```bash
git clone https://github.com/sudheer997/Deccan-Car-Rental.git
cd Deccan-Car-Rental
```

#### 2. Install Dependencies
**IMPORTANT**: This project requires Yarn, not npm!
```bash
# Install Yarn globally if needed
npm install -g yarn

# Install project dependencies
yarn install
```

#### 3. Environment Variables Setup

Create `.env.local` for local development:
```bash
# .env.local (NOT committed to Git)
MONGO_URL=mongodb://localhost:27017/deccan_car_rental_dev
DB_NAME=deccan_car_rental_dev
NEXT_PUBLIC_BASE_URL=http://localhost:3000
CORS_ORIGINS=*

EMAIL_PROVIDER=gmail
EMAIL_USER=test@example.com
EMAIL_PASSWORD=test-password
ADMIN_EMAIL=admin@example.com
COMPANY_NAME=Deccan Car Rental
COMPANY_PHONE=+1-XXX-XXX-XXXX
```

Create `.env.example` for team reference (safe to commit):
```bash
MONGO_URL=your_mongodb_connection_string
DB_NAME=your_database_name
NEXT_PUBLIC_BASE_URL=your_app_url
# ...etc
```

#### 4. Start MongoDB with Docker
```bash
# Start MongoDB and Mongo Express
docker-compose up -d

# Verify containers are running
docker ps

# Access Mongo Express UI at http://localhost:8081
# Username: admin, Password: admin123
```

#### 5. Run Development Server
```bash
yarn dev
```

Application will be available at:
- **Local**: http://localhost:3000
- **Mongo Express**: http://localhost:8081

---

## 🔀 Git Workflow & Branching Strategy

### Branch Structure
```
main (production)
  ↓
staging (pre-production)
  ↓
develop (integration)
  ↓
feature/* | bugfix/* | hotfix/*
```

### Branch Rules

| Branch | Purpose | Deploy Target | Protection |
|--------|---------|---------------|-----------|
| `main` | Production code | Vercel Production | Requires PR + 1 approval |
| `staging` | Pre-release testing | Vercel Staging | Requires PR |
| `develop` | Integration branch | Vercel Preview | Open for team |
| `feature/*` | New features | Auto-preview | No restrictions |
| `hotfix/*` | Critical fixes | Fast-track to main | Emergency only |

### Workflow Example

```bash
# Create feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/customer-dashboard

# Make changes and commit
git add .
git commit -m "feat: add customer dashboard with analytics"

# Push and create Pull Request
git push origin feature/customer-dashboard
```

### Commit Message Convention
Follow Conventional Commits:
```
feat: add new feature
fix: bug fix
docs: documentation changes
style: formatting, missing semicolons
refactor: code restructuring
test: adding tests
chore: updating build tasks, configs
```

---

##  CI/CD Pipeline Architecture

### Pipeline Flow Diagram
```
┌─────────────────────────────────────────────────────────────────┐
│                    DEVELOPER WORKFLOW                            │
│  Local Dev → Commit → Push → Pull Request → Code Review         │
└────────────────────────┬─────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Actions CI/CD                          │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  PR Validation (on pull_request)                         │   │
│  │  ├─ ESLint & Prettier                                    │   │
│  │  ├─ Type checking                                        │   │
│  │  ├─ Unit tests                                           │   │
│  │  ├─ Build verification                                   │   │
│  │  ├─ Security scan (npm audit)                            │   │
│  │  └─ Lighthouse CI (performance)                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                         ↓                                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Deploy to Staging (on push to 'staging')                │   │
│  │  ├─ Build Next.js app                                    │   │
│  │  ├─ Run integration tests                                │   │
│  │  ├─ Deploy to Vercel (staging)                           │   │
│  │  └─ Run smoke tests                                      │   │
│  └──────────────────────────────────────────────────────────┘   │
│                         ↓                                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Deploy to Production (on push to 'main')                │   │
│  │  ├─ Build production bundle                              │   │
│  │  ├─ Deploy to Vercel (production)                        │   │
│  │  ├─ Post-deployment health check                         │   │
│  │  └─ Notify team (Slack/Email)                            │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Deployment Configuration

### Vercel Setup

#### 1. Connect GitHub Repository
```bash
# Via Vercel CLI
npm i -g vercel
vercel login
vercel link
```

#### 2. Configure Environment Variables

**Production** (`vercel.com/your-project/settings/environment-variables`):
```
MONGO_URL=mongodb+srv://...
DB_NAME=deccan_production
NEXT_PUBLIC_BASE_URL=https://yourdomain.com
EMAIL_PROVIDER=smtp
EMAIL_USER=noreply@yourdomain.com
# ...etc
```

**Staging**:
```
MONGO_URL=mongodb+srv://...
DB_NAME=deccan_staging
NEXT_PUBLIC_BASE_URL=https://staging.yourdomain.com
# ...etc
```

#### 3. Domain Configuration

In Vercel Project Settings → Domains:
```
Production: yourdomain.com + www.yourdomain.com
Staging: staging.yourdomain.com
```

In your domain registrar (GoDaddy, Namecheap, etc.):
```dns
A Record:  @  →  76.76.21.21 (Vercel IP)
CNAME:  www  →  cname.vercel-dns.com
CNAME:  staging  →  cname.vercel-dns.com
```

---

## 🔒 Security & Secrets Management

### Secret Storage Strategy

| Environment | Tool | Purpose |
|-------------|------|---------|
| Local | `.env.local` (gitignored) | Development secrets |
| CI/CD | GitHub Secrets | Build-time variables |
| Vercel | Vercel Environment Variables | Runtime secrets |
| Production | Vercel + Vault (optional) | Sensitive credentials |

### Never Commit:
- `.env`, `.env.local`, `.env.production`
- API keys, passwords, connection strings
- `credentials.json`, `token.json`
- Private keys (`.pem`, `.key` files)

### GitHub Secrets Setup
```bash
# Go to: https://github.com/your-repo/settings/secrets/actions
# Add these secrets:
MONGO_URL_STAGING
MONGO_URL_PRODUCTION
VERCEL_TOKEN
VERCEL_ORG_ID
VERCEL_PROJECT_ID
```

---

## 📁 Project Structure

```
deccan-car-rental/
├── .github/
│   └── workflows/           # CI/CD pipelines
│       ├── pr-validation.yml
│       ├── deploy-staging.yml
│       └── deploy-production.yml
├── .husky/                  # Git hooks
│   ├── pre-commit
│   └── pre-push
├── app/                     # Next.js app directory
│   ├── api/                # API routes
│   ├── components/         # React components
│   └── page.js             # Main page
├── components/ui/           # Reusable UI components
├── lib/                     # Utility functions
├── public/                  # Static assets
├── tests/                   # Test files
├── .env.example             # Template for environment variables
├── .env.local               # Local secrets (gitignored)
├── .gitignore
├── docker-compose.yml       # Local MongoDB setup
├── next.config.js
├── package.json
├── tailwind.config.js
└── yarn.lock
```

---

## 🧪 Testing Strategy

### Test Types

```bash
# Unit Tests (Jest + React Testing Library)
yarn test

# Integration Tests
yarn test:integration

# E2E Tests (Playwright)
yarn test:e2e

# Lint
yarn lint

# Type Check
yarn type-check
```

### Test Coverage Goals
- Unit Tests: 80%+ coverage
- API Routes: 100% coverage
- Critical Paths: E2E coverage

---

## 📊 Monitoring & Observability

### Production Monitoring Tools

1. **Vercel Analytics** - Built-in metrics
2. **Sentry** - Error tracking
3. **LogRocket** - Session replay
4. **MongoDB Atlas** - Database monitoring

### Health Check Endpoint
```javascript
// app/api/health/route.js
export async function GET() {
  return Response.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: process.env.NEXT_PUBLIC_APP_VERSION
  });
}
```

---

## 🔧 Troubleshooting

### Common Issues

#### 1. Dependencies Not Installing
```bash
# Solution: Use Yarn, not npm
rm -rf node_modules package-lock.json
yarn install
```

#### 2. MongoDB Connection Failed
```bash
# Check Docker containers
docker ps

# Restart MongoDB
docker-compose restart mongodb
```

#### 3. Next.js Build Errors
```bash
# Clear .next cache
rm -rf .next
yarn dev
```

#### 4. Port Already in Use
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Or use different port
yarn dev -p 3001
```

---

## 📚 Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Vercel Deployment Guide](https://vercel.com/docs)
- [MongoDB Atlas Setup](https://www.mongodb.com/docs/atlas/)
- [GitHub Actions Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)

---

## 👥 Team Contacts

- **Tech Lead**: [Name] - [email]
- **DevOps**: [Name] - [email]
- **Support**: support@yourdomain.com

---

**Last Updated**: January 2026
**Maintained By**: Development Team
