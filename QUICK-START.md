# 🚀 Quick Start Guide - Deccan Car Rental

## ✅ What's Already Set Up

Your local environment is ready with:
- ✅ Repository cloned to: `/Users/ramukamepalli/deccan-car-rental`
- ✅ All dependencies installed with Yarn
- ✅ MongoDB running in Docker (port 27017)
- ✅ Mongo Express UI available (port 8081)
- ✅ Environment variables configured
- ✅ Next.js upgraded to v15.5.9
- ✅ Development server configured

---

## 🎯 What You Need to Update

### 1. Environment Variables (⚠️ CRITICAL)

The current `.env` file has real credentials committed to Git - **this is a security risk**!

**ACTION REQUIRED:**

```bash
# 1. Remove .env from Git tracking
git rm --cached .env
echo ".env" >> .gitignore

# 2. Update .env.local with your real credentials
# Open /Users/ramukamepalli/deccan-car-rental/.env.local
# Replace these values:
```

**File to edit**: [.env.local](/Users/ramukamepalli/deccan-car-rental/.env.local)

```bash
# YOUR MongoDB credentials (get from MongoDB Atlas)
MONGO_URL=your_real_mongodb_connection_string
DB_NAME=your_database_name

# YOUR email credentials (for notifications)
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-specific-password
ADMIN_EMAIL=your-admin@email.com
COMPANY_PHONE=your-phone-number
```

### 2. GitHub Secrets for CI/CD

Go to: `https://github.com/sudheer997/Deccan-Car-Rental/settings/secrets/actions`

Add these secrets:
```
VERCEL_TOKEN - Get from https://vercel.com/account/tokens
VERCEL_ORG_ID - Get from Vercel project settings
VERCEL_PROJECT_ID - Get from Vercel project settings
MONGO_URL_PRODUCTION - Your production MongoDB URL
MONGO_URL_STAGING - Your staging MongoDB URL
```

### 3. Vercel Project Setup

```bash
# Install Vercel CLI
npm i -g vercel

# Login and link project
vercel login
vercel link

# Add environment variables in Vercel dashboard
# https://vercel.com/ramas-projects-859406c2/deccancarrental/settings/environment-variables
```

---

## 🏃 How to Run the Code

### Option 1: Using Terminal

```bash
# Navigate to project directory
cd /Users/ramukamepalli/deccan-car-rental

# Start MongoDB (if not running)
docker-compose up -d

# Start development server
yarn dev
```

Access the app at:
- **Frontend**: http://localhost:3000
- **Database UI**: http://localhost:8081 (admin/admin123)

### Option 2: Using VS Code

1. **Open Project in VS Code**:
   ```bash
   code /Users/ramukamepalli/deccan-car-rental
   ```

2. **Install Recommended Extensions**:
   - ESLint
   - Prettier
   - Tailwind CSS IntelliSense
   - GitLens

3. **Use Integrated Terminal** (`` Ctrl+` ``):
   ```bash
   yarn dev
   ```

4. **Debugging in VS Code**:

   Create [.vscode/launch.json](.vscode/launch.json):
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Next.js: debug server-side",
         "type": "node-terminal",
         "request": "launch",
         "command": "yarn dev"
       }
     ]
   }
   ```

---

## 📂 Key Files to Know

| File | Purpose | When to Edit |
|------|---------|--------------|
| [.env.local](.env.local) | Local secrets | Initial setup |
| [next.config.js](next.config.js) | Next.js configuration | Rarely |
| [package.json](package.json) | Dependencies & scripts | Adding packages |
| [docker-compose.yml](docker-compose.yml) | Local MongoDB setup | Rarely |
| [app/page.js](app/page.js) | Homepage | Frequently |
| [app/api/](/app/api/) | API routes | Adding endpoints |
| [tailwind.config.js](tailwind.config.js) | Styling config | Design changes |

---

## 🔍 Development Workflow

### Daily Development

```bash
# 1. Pull latest changes
git pull origin develop

# 2. Create feature branch
git checkout -b feature/your-feature-name

# 3. Start development server
yarn dev

# 4. Make changes, test locally

# 5. Commit changes
git add .
git commit -m "feat: your feature description"

# 6. Push and create PR
git push origin feature/your-feature-name
```

### Making Changes

1. **Frontend Changes**: Edit files in [/app](/app) directory
2. **API Changes**: Edit files in [/app/api](/app/api)
3. **UI Components**: Edit files in [/components/ui](/components/ui)
4. **Styles**: Edit [/app/globals.css](/app/globals.css) or component files

---

## 🐛 Troubleshooting

### Server won't start?

```bash
# Clear Next.js cache
rm -rf .next

# Reinstall dependencies
rm -rf node_modules
yarn install

# Restart
yarn dev
```

### MongoDB connection error?

```bash
# Check Docker containers
docker ps

# Restart MongoDB
docker-compose restart mongodb

# View logs
docker-compose logs mongodb
```

### Port 3000 already in use?

```bash
# Find and kill process
lsof -ti:3000 | xargs kill -9

# Or use different port
yarn dev -p 3001
```

---

## 📞 Next Steps

1. ✅ **Review Documentation**: Read [DEVOPS-SETUP.md](DEVOPS-SETUP.md)
2. ⚠️ **Update Secrets**: Follow "What You Need to Update" section above
3. 🔧 **Configure Vercel**: Set up production deployment
4. 🧪 **Test Locally**: Ensure app runs without errors
5. 🚀 **First Deployment**: Push to staging, then production

---

## 💡 Useful Commands

```bash
# Development
yarn dev              # Start dev server
yarn build            # Build for production
yarn start            # Start production server

# Database
docker-compose up -d      # Start MongoDB
docker-compose down       # Stop MongoDB
docker-compose logs       # View logs

# Git
git status                # Check changes
git log --oneline         # View commit history
git branch               # List branches

# Vercel
vercel                   # Deploy to preview
vercel --prod            # Deploy to production
vercel logs              # View deployment logs
```

---

## 📧 Support

If you encounter issues:
1. Check [DEVOPS-SETUP.md](DEVOPS-SETUP.md) troubleshooting section
2. Review error logs in terminal
3. Check MongoDB connection in Mongo Express (http://localhost:8081)
4. Verify environment variables are set correctly

---

**Ready to start coding!** 🎉

Open VS Code, run `yarn dev`, and start building!
