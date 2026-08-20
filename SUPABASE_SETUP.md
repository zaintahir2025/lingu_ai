# 🚀 Lingu AI - Supabase Setup Guide

This guide details how to connect your **Lingu AI** app to **Supabase** for 100% free cloud authentication, progress sync, and database storage!

---

## 📋 Step 1: Create a Free Supabase Project

1. Go to [supabase.com](https://supabase.com) and click **Start your project** (Free Forever).
2. Create a new Organization & Project (e.g. `Lingu-AI`).
3. Set your Database Password and choose a region close to your users.
4. Wait 1-2 minutes for your database to provision.

---

## ⚡ Step 2: Run the SQL Schema

1. Open your Supabase Dashboard.
2. Click on the **SQL Editor** tab on the left sidebar (`/project/_/sql`).
3. Click **New Query**.
4. Open the `supabase_schema.sql` file in this repository, copy all contents, paste it into the editor, and click **Run**.

*(This creates the `profiles`, `user_progress`, `support_tickets` tables with automatic triggers and RLS security).*

---

## 🔑 Step 3: Get Your API Credentials

1. In Supabase Dashboard, go to **Project Settings** -> **API** (`/project/_/settings/api`).
2. Copy your **Project URL** (e.g., `https://abcdefgh.supabase.co`).
3. Copy your **anon / public** API Key (e.g., `eyJhbGciOiJIUzI1Ni...`).

---

## 📱 Step 4: Run / Deploy App with Credentials

Pass your credentials when running or building the app:

```bash
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your_anon_key
```

Or for GitHub Actions / Web deployment, add `SUPABASE_URL` and `SUPABASE_ANON_KEY` to your GitHub Repository Secrets!

---

## 🎯 What Supabase Handles for Lingu AI:
- ✅ **Authentication**: Sign up, Login, Logout, Password Reset.
- ✅ **Automatic Profile Creation**: Trigger automatically sets up user profile & progress on signup.
- ✅ **User Progress**: Cloud sync for XP, Streaks, Levels, and Gems.
- ✅ **Support Tickets**: Live customer support system.
