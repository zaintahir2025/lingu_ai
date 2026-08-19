# LinguAI — Modern Gamified AI Language Learning App

LinguAI is an original, gamified language-learning application that combines short interactive lessons, spaced repetition, native-locale pronunciation, and contextual AI explanations. It borrows proven learning principles from products such as Duolingo and Anki without copying their identity or interface. LinguAI has its own mint-teal visual system and one official companion: Piko, the parrot-robot tutor.

![LinguAI official logo](assets/images/brand/linguai_official_logo.png)

Live Web Application: https://zaintahir2025.github.io/lingu_ai/
GitHub Repository: https://github.com/zaintahir2025/lingu_ai

---

## Key Features and Highlights

### 1. Target Learning Languages
Users can learn multiple global languages with curated vocabulary words, native example sentences, and script quizzes:
- Spanish
- French
- Japanese (Latin and Kanji/Kana script support with responsive font scaling)
- German

### 2. Dual Interface Localization (English and Urdu)
- The app UI can be toggled seamlessly between English and Urdu.
- Translates all interface navigation, headers, button labels, quiz options, flashcards, settings, and profile info into Urdu script (app_ur.arb) or English (app_en.arb).

### 3. Personal AI Language Tutor (Gemini API)
- Gated feature for LinguAI PRO Members.
- Interactive conversational AI powered by Google Gemini API (x-goog-api-key header integration with key sanitization and multi-endpoint fallback).
- Helps users practice target language dialogues, receive grammatical corrections, and get instant feedback.

### 4. Spaced Repetition System (SRS Vocab and Quizzes)
- Uses an adaptive SuperMemo-style SRS algorithm tracking repetitions, interval, easinessFactor, and nextReviewDate.
- Review Session Screen: Swipeable flashcards with flip animation, pronunciation audio, and example sentences.
- Multiple Choice Quizzes: Dynamic question generation for Latin and Non-Latin scripts (Japanese/Urdu) translated via VocabTranslator.

### 5. Native Speech Accent TTS and Adjustable Speed Control
- Sets explicit BCP-47 language locale tags before speaking (es-ES, fr-FR, ja-JP, de-DE, ur-PK, en-US) for authentic native accents.
- Ranks installed voices by exact locale and neural, natural, enhanced, premium, Google, Microsoft, Siri, or WaveNet quality markers while avoiding compact, synthetic, and robotic voices.
- Keeps English instructions and target-language words on their correct voice locales so an English prompt is not read with a Spanish, French, German, Japanese, or Urdu voice.
- Provides a 0.5x–1.5x pronunciation pace control and subtle emotion-aware prosody without distorting native pronunciation.
- Uses Web Speech synthesis on browsers and the best installed native speech engine on mobile and desktop. Final quality depends on the language packs installed on the device.

### 6. LinguAI PRO Membership and Payment Gateway
- Stripe-hosted recurring subscription checkout and customer billing portal.
- Premium access is activated only after the backend verifies a signed Stripe webhook; card details never enter the app or LinguAI backend.
- PRO Benefits:
  - Unlimited 24/7 AI Language Tutor
  - 100% Ad-Free Experience (Suppresses AdMob banners)
  - Unlimited Hearts Mode (Infinite lives)
  - Priority Customer Support Desk

### 7. Admin Control Panel (/admin)
Administrators see authenticated, server-backed operations only:
1. Registered accounts, verification state, role, Stripe-verified premium status, suspension, restoration, and confirmed deletion.
2. Priority customer-support inbox with real server-side replies and deletion.
3. Integration-health monitoring and an immutable administrative action history.
4. Premium billing remains Stripe-managed so the client cannot fabricate access.

During QA, `TESTING_ADMIN_ACCESS=true` grants every authenticated account access
without changing its stored role. Set it to `false` before launch. Permanent
administrator roles are stored in PostgreSQL and managed by the Dart backend.

### 8. Gamification and Daily Motivation
- XP and Knowledge Levels: Earn XP from completed lessons and quizzes to advance levels (A1 Beginner, A2 Intermediate, etc.).
- Streak Counter: Tracks consecutive daily learning sessions.
- Hearts System: Challenge mode (5 hearts) vs Unlimited Hearts mode.
- Course Unenroll / Progress Reset: Switch or unenroll language courses with a clear confirmation warning modal that resets unlocked levels and review cards.

### 9. Modern Aesthetic Design and App Branding
- Piko, LinguAI's original parrot-robot companion, is the single official character across lessons, tutor messages, achievements, app icons, logo, and favicon.
- Piko has dedicated animated GIF loops for idle, thinking, encouraging, mistake-recovery, and celebration states. Reduced-motion users automatically receive the official static PNG.
- Correct, incorrect, completion, navigation, achievement, and level-up events include restrained audio/haptic feedback.
- Dark Royal Purple and Gold Shimmer PRO Cards with clean badges.
- Fully responsive design matching desktop, tablet, and mobile browsers.

---

## Supported Platforms

The same Flutter codebase targets:

- Android and iOS
- Web browsers
- Windows 10 1809 or newer
- macOS 10.15 or newer
- Modern Linux distributions with GTK 3

Registration uses Cloudflare Turnstile on every target. Web uses a native HTML
platform view; native apps use the system WebView. Production builds must pass
`TURNSTILE_SITE_KEY` with `--dart-define` and configure the matching
`TURNSTILE_SECRET_KEY` on the backend. Debug builds use Cloudflare's official
always-pass testing pair.

Linux builds additionally need the system libraries used by audio and WebView:

```bash
# Ubuntu/Debian
sudo apt-get install libgtk-3-dev libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev libwebkit2gtk-4.1-dev

# Fedora/RHEL
sudo dnf install gtk3-devel gstreamer1-devel \
  gstreamer1-plugins-base-devel webkit2gtk4.1-devel
```

Windows requires the Microsoft Edge WebView2 runtime, which is included with
current Windows 10 and Windows 11 installations.

## Technology Stack

- Framework: Flutter for web, mobile, and desktop (Dart 3.x)
- State Management: Riverpod 2.x (StateNotifierProvider, Provider)
- Database and Persistence:
  - Drift (SQLite) with WebAssembly (WASM) worker for browser database storage.
  - Hive key-value storage for user settings and cached server-verified subscription state.
- Backend: Dart, Serverpod, PostgreSQL, JWT refresh-token rotation, Stripe, SMTP, and Cloudflare Turnstile.
- Routing: GoRouter
- Audio and TTS: flutter_tts with dynamic BCP-47 locale configuration.
- AI Integration: Google Gemini REST API via http.
- Localization: Flutter gen-l10n (app_en.arb, app_ur.arb).

## Product Flow

1. Register with email, a strong password, age confirmation, and Cloudflare Turnstile.
2. Verify the email and sign in with rotating access and refresh tokens.
3. Choose a target language and complete the placement/onboarding survey.
4. Follow the lesson path, study flashcards, hear native-locale pronunciation, and complete mixed quiz exercises.
5. Ask Piko for an explanation from inside a quiz. Returning closes the explanation and resumes the same question rather than restarting the quiz.
6. Review due vocabulary with the SM-2 scheduler. Review level 1 contains 30 previously learned words; later levels grow by 15 words.
7. Resume the last active route, lesson step, draft, or quiz state after navigating away or reopening the app.
8. Earn XP, maintain streaks, unlock achievements, and compare progress on the leaderboard.

## Piko Brand System

The project intentionally contains one character identity. Obsolete owl, bear, robot, child, avatar, and red-panda artwork was removed.

| Asset | Purpose |
| --- | --- |
| `piko_official_master.png` | Transparent source artwork and reduced-motion fallback |
| `piko_app_icon.png` | Source for Android, iOS, macOS, Windows, and web icons |
| `linguai_official_logo.png` | Official Piko + LinguAI wordmark |
| `animations/piko_idle.gif` | Navigation, login, tutor, and general waiting state |
| `animations/piko_thinking.gif` | AI explanation and thinking state |
| `animations/piko_encouraging.gif` | Lesson prompts and retry encouragement |
| `animations/piko_sad.gif` | Gentle mistake/offline recovery state |
| `animations/piko_celebrating.gif` | Correct answers, achievements, and level completion |

## Frontend Architecture

- `lib/core`: networking, persistence, responsive layout, audio, advertisements, notifications, routing, theme, synchronization, and shared components.
- `lib/features/auth`: registration, verification, login, token restoration, and logout.
- `lib/features/learn`: curriculum, lesson path, modules, vocabulary, and flashcards.
- `lib/features/quiz`: exercise generation, feedback, draft restoration, and in-quiz tutor explanations.
- `lib/features/review`: level quotas and SM-2 review sessions.
- `lib/features/tutor`: Gemini/Groq BYOK settings, server-backed tutor access, chat state, and paywall.
- `lib/features/progress`: XP, streaks, achievements, leaderboard, profile, goals, support, and settings.
- `lib/features/admin`: authenticated account, support, integration-health, and audit operations.
- Riverpod owns application state; GoRouter owns route restoration; Drift and Hive provide local/offline persistence.

## Dart Backend Architecture

The backend is entirely Dart and lives in `linguai_backend/`:

- Serverpod REST-compatible web routes on `/api/v1`.
- PostgreSQL models and repeatable migrations.
- BCrypt password hashing and short-lived JWT access tokens.
- Hashed, rotating refresh tokens with logout and account-disable invalidation.
- Email verification and password reset through SMTP.
- Cloudflare Turnstile server verification.
- Profile, lesson, progress, draft, state synchronization, review, leaderboard, support, admin, AI tutor, subscription, and webhook operations.
- Signed Stripe webhook verification and server-owned premium state.
- Administrative audit records for destructive or privileged actions.

The Flutter client never treats locally edited premium/admin values as authoritative.

## Environment Configuration

Frontend build-time values:

| Variable | Required | Description |
| --- | --- | --- |
| `API_URL` | Release | Public HTTPS Dart API base, including `/api/v1` |
| `TURNSTILE_SITE_KEY` | Registration | Cloudflare Turnstile site key |
| `ADMOB_ANDROID_BANNER_ID` | Android ads | Production Android banner unit |
| `ADMOB_IOS_BANNER_ID` | iOS ads | Production iOS banner unit |

Backend values are documented in `linguai_backend/linguai_backend_server/.env.example`. Important production values include `JWT_SECRET`, PostgreSQL credentials, SMTP credentials, Turnstile secret, Gemini key, Stripe secret, price ID, webhook secret, and public app/API URLs. Never commit real credentials.

## Security and Privacy Notes

- Passwords, raw refresh tokens, card numbers, and BYOK provider keys are not stored as readable server data.
- Authentication, support, and AI requests are rate-limited.
- Account deletion removes dependent user data.
- CAPTCHA is validated by the backend; hiding a widget in the client cannot bypass it.
- Stripe card entry occurs on Stripe-hosted pages.
- `TESTING_ADMIN_ACCESS=true` is strictly a QA switch. Set it to `false` before a public production launch.
- Store privacy disclosures, legal text, data-safety forms, production monitoring, backups, and signing credentials remain deployment-owner responsibilities.

## Quality Gates

The root workflows verify:

- Flutter formatting/analyzer and automated tests.
- Dart backend analyzer and unit tests.
- Web release compilation.
- Android debug compilation with Java 21.
- Linux, Windows, macOS, and unsigned iOS builds on their native GitHub Actions hosts.
- GitHub Pages deployment from `main` to the orphaned `gh-pages` branch.

Run the main local checks with:

```bash
flutter analyze
flutter test
flutter build web --release --base-href /lingu_ai/ \
  --dart-define=API_URL=https://your-api.example/api/v1 \
  --dart-define=TURNSTILE_SITE_KEY=your-site-key

cd linguai_backend/linguai_backend_server
dart analyze --fatal-infos
dart test
```

---

## Repository Structure

```
lingu_ai/
├── assets/
│   ├── images/brand/            # Official Piko master, app icon, and logo
├── lib/
│   ├── core/
│   │   ├── ads/                 # Google AdMob Banner and Interstitial Widgets
│   │   ├── audio/               # TtsService and Speed Rate Providers
│   │   ├── database/            # Drift SQLite VocabWords and Lessons tables
│   │   ├── game_state/          # Hearts, Streak and XP Storage
│   │   ├── router/              # AppRouter GoRouter navigation configuration
│   │   ├── storage/             # Token, Premium and Onboarding Storage
│   │   └── widgets/             # Shared UI components and Premium badges
│   ├── features/
│   │   ├── admin/               # Server-backed Accounts and Support Dashboard
│   │   ├── auth/                # AuthController and Authentication screens
│   │   ├── home/                # HomeScreen and Adaptive Bottom Navigation
│   │   ├── learn/               # LearnTab, VocabTranslator and Flashcards
│   │   ├── payment/             # Stripe Checkout and Billing Portal
│   │   ├── progress/            # ProfileTab and ContactUsScreen
│   │   ├── quiz/                # QuizController and QuizScreen
│   │   ├── review/              # ReviewSessionScreen (SRS Spaced Repetition)
│   │   └── tutor/               # TutorScreen (Gemini AI Tutor Chat)
│   └── l10n/                    # AppLocalizations ARB translation files
├── linguai_backend/
│   └── linguai_backend_server/ # Dart Serverpod API, models and migrations
├── web/                         # Web configuration, index.html, favicon and icons
├── pubspec.yaml
└── README.md
```

---

## Getting Started Locally

### Prerequisites
- Flutter SDK (v3.19 or higher)
- Dart SDK
- Serverpod CLI (`dart pub global activate serverpod_cli`)
- PostgreSQL 16 (Docker or Podman is convenient locally)
- SMTP, Stripe, Turnstile, and Gemini credentials for their production features

### Installation Steps

1. Clone the Repository:
   ```bash
   git clone https://github.com/zaintahir2025/lingu_ai.git
   cd lingu_ai
   ```

2. Install Dependencies:
   ```bash
   flutter pub get
   cd linguai_backend && dart pub get && cd ..
   ```

3. Run Code Generation (if modifying database schemas):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Configure the values described in
   `linguai_backend/linguai_backend_server/.env.example`, start PostgreSQL,
   apply migrations, and start the Dart API:

   ```bash
   cd linguai_backend/linguai_backend_server
   docker compose up -d postgres postgres_test
   dart run bin/main.dart --apply-migrations
   ```

5. Launch Application:
   - For Web:
     ```bash
     flutter run -d chrome
     ```
   - For Desktop / Mobile:
     ```bash
     flutter run
     ```

   For a production-like local run, provide the backend and CAPTCHA settings:

   ```bash
   flutter run --dart-define=API_URL=https://your-api.example/api/v1 \
     --dart-define=TURNSTILE_SITE_KEY=your-site-key
   ```

6. Build Production Web Bundle (the release API URL is mandatory):
   ```bash
   flutter build web --base-href "/lingu_ai/" \
     --dart-define=API_URL=https://your-api.example/api/v1 \
     --dart-define=TURNSTILE_SITE_KEY=your-site-key
   ```

---

## License
Distributed under the MIT License. See LICENSE for more information.
