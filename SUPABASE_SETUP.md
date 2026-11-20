# LinguAI — Supabase setup

## 1. Configure Supabase

Create a Supabase project, then run `supabase_schema.sql` in the SQL Editor.

For a project that has already used the older schema, review and apply:

`supabase/migrations/202611200001_security_hardening.sql`

**Important:** this migration changes all current `is_premium` values to false. The previous app and schema could grant PRO by default, so existing entitlements must be checked against real payment records before being restored. Do not run it without reviewing that effect.

## 2. Configure client credentials

Copy the Project URL and the publishable (or legacy anon/public) key from Supabase Project Settings → API.

Run locally with:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=your_publishable_key
```

You can use `SUPABASE_ANON_KEY` instead of `SUPABASE_PUBLISHABLE_KEY` for older Supabase projects.

For GitHub Pages, add these repository Actions secrets:
- `SUPABASE_URL`
- `SUPABASE_PUBLISHABLE_KEY` (or `SUPABASE_ANON_KEY`)

Never place a Supabase `service_role` / secret key in Flutter, GitHub Pages build variables, or any client-side file.

## 3. Current integration boundaries

This repository contains the Flutter client, local Drift database and Supabase client/schema. It does **not** currently contain the Serverpod/API backend source described in some older README sections.

The Flutter app has optional REST API calls controlled by `API_URL`. AI proxy, cloud XP sync, admin operations and Stripe checkout require a separately deployed server that implements the expected API contract. Without that server, those features report an unavailable service; the app must not invent successful results.

The Gemini key entered by a user is a user-owned key used for direct client requests. Do not put a shared Gemini key in the Flutter app.

Stripe entitlement is granted only after a server verifies the subscription. Configure no client-side shortcut or service-role key to bypass that check.
