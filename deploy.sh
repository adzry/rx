#!/usr/bin/env bash
set -e
echo "🚀 YLGO Local Deploy: Supabase + Vercel + Fly.io"
# --- ENV VARIABLES ---
export SUPABASE_URL="https://baugyhxqcfsfljxqxfup.supabase.co"
export SUPABASE_SERVICE_ROLE="SUPABASE AI"
export SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJhdWd5aHhxY2ZzZmxqeHF4ZnVwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwMDA2ODYsImV4cCI6MjA3MzU3NjY4Nn0.qYAPv6tXCgKtdVlmhL7MvNaXSvJY4QiKxun6R20SXwc"
export DATABASE_URL="https://baugyhxqcfsfljxqxfup.supabase.co"
export VERCEL_TOKEN="mVsZnQT2bIJVMdE7m1r4ZV5k"
export FLY_API_TOKEN="fo1_bJJWGm0mY794dr-HgIC5S7UxPfJd63lTgKXGP8dbb6I"

# --- STEP 1: Sync Excel → Supabase ---
echo "📥 Syncing Excel to Supabase..."
pip install -q pandas openpyxl supabase
python ingest_excel.py indentSupplyDtlExcel.xlsx || { echo "❌ Supabase ingestion failed"; exit 1; }

# --- STEP 2: Build Next.js frontend ---
echo "⚙️ Building Next.js frontend..."
npm ci
npm run build

# --- STEP 3: Deploy to Vercel ---
echo "🌐 Deploying to Vercel..."
npx vercel --prod --token=$VERCEL_TOKEN || { echo "❌ Vercel deploy failed"; exit 1; }

# --- STEP 4: Deploy to Fly.io ---
echo "🚀 Deploying to Fly.io..."
fly deploy --remote-only --token=$FLY_API_TOKEN || { echo "❌ Fly.io deploy failed"; exit 1; }

echo "✅ All done! Supabase synced, Vercel + Fly.io deployed."
