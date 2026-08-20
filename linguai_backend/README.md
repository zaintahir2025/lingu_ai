# LinguAI Dart backend

The production backend is implemented in Dart with Serverpod. It provides
PostgreSQL persistence, JWT access tokens with rotating hashed refresh tokens,
email verification and password reset, rate-limited authentication,
profile and survey APIs, durable progress sync, support and administration,
Gemini tutor access, and Stripe subscription management with signed webhooks.

## Local development

From the repository root, the shortest supported startup command is:

```bash
./tool/start_local_backend.sh
```

It reuses Podman or Docker, creates the project-scoped PostgreSQL container when
needed, waits for database readiness, applies committed migrations, and starts
the API on `http://localhost:3000/api/v1`. Without SMTP credentials, local email
verification and password-reset links are printed in that terminal.

1. Copy `linguai_backend_server/.env.example` to a private environment file or
   export the values in your shell.
2. Start PostgreSQL with `docker compose up -d postgres postgres_test` (Podman
   can run the same images).
3. From `linguai_backend_server`, run:

   ```bash
   dart pub get
   serverpod generate
   serverpod create-migration --tag your-change
   dart run bin/main.dart --apply-migrations
   ```

The Flutter app uses `http://localhost:3000/api/v1` on web/desktop and
`http://10.0.2.2:3000/api/v1` on the Android emulator. Production builds must
set `API_URL` with `--dart-define`.

Serverpod secrets in `config/passwords.yaml` and runtime `.env` files are
ignored by Git. Commit migrations, generated protocol files, and model YAML.

## Release checks

Run these before deployment:

```bash
cd linguai_backend_server
dart analyze
dart test

cd ../..
flutter analyze
flutter test
flutter build web --release --dart-define=API_URL=https://api.example.com/api/v1
```
