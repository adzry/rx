#!/usr/bin/env bash
set -e

echo "🤖 Copilot Auto-Fix Deploy Starting..."

# Step 1: Try local lint/build before push
echo "🔍 Running local checks..."
npm install
npm run lint || echo "⚠️ Lint warnings, proceeding..."
npm run build || { echo "❌ Build failed. Fix errors before pushing."; exit 1; }

# Step 2: Add all changes
echo "📥 Staging changes..."
git add .

# Step 3: Auto-commit with timestamp
echo "📝 Committing changes..."
git commit -m "Copilot Auto Fix @ $(date '+%Y-%m-%d %H:%M:%S')" || echo "⚠️ Nothing to commit"

# Step 4: Push to GitHub
echo "⬆️ Pushing to origin/main..."
git push origin main

# Step 5: Run deploy manually (bypasses Actions billing)
echo "🚀 Running local deploy..."
./deploy.sh

echo "✅ Copilot Auto-Fix Deploy Completed"
