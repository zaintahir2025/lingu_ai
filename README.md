# LinguAI - Enterprise Grade Gamified AI Language Learning Platform

LinguAI is an industry-grade, cross-platform language learning application engineered with Flutter and Dart Serverpod. The system integrates SuperMemo (SM-2) spaced repetition algorithms, real-time contextual AI tutoring via Google Gemini REST APIs, native speech synthesis, bi-directional localization (English and Urdu), and enterprise security patterns including JWT token rotation and server-verified Stripe monetization.

Live Web Application: https://zaintahir2025.github.io/lingu_ai/
GitHub Repository: https://github.com/zaintahir2025/lingu_ai

---

## 1. System Overview and Key Capabilities

### 1.1 Multi-Language Support and Script Engine
LinguAI provides structured lesson tracks, vocabulary data, script practice, and pronunciation tools for multiple international languages:
* Spanish (Es)
* French (Fr)
* German (De)
* Japanese (Ja - Latin and Kanji/Kana script rendering with script-aware dynamic typography)

### 1.2 Dual Interface Localization (English and Urdu)
* Full bi-directional localization support using Flutter ARB files (`app_en.arb` and `app_ur.arb`).
* Dynamic right-to-left (RTL) layout switching and localized UI components for navigation, settings, quizzes, flashcards, and modals.

### 1.3 Adaptive Conversational AI Tutor
* Contextual language tutoring powered by Google Gemini API integrations.
* Client-side BYOK (Bring Your Own Key) support alongside server-hosted proxy execution for PRO tier subscribers.
* Real-time grammar corrections, vocabulary explanations, and natural conversational dialogue practice.

### 1.4 SuperMemo (SM-2) Spaced Repetition Engine
* Algorithmic scheduling of review intervals based on user recall performance.
* Tracks repetition count, easiness factor (EF), and target interval days per vocabulary word.
* Level-based card scaling: Base level reviews contain 30 cards, expanding adaptively by 15 cards per mastery tier.

### 1.5 BCP-47 Native Accent TTS Engine
* Locale-aware text-to-speech rendering matching native accent codes (`es-ES`, `fr-FR`, `ja-JP`, `de-DE`, `ur-PK`, `en-US`).
* Voice ranking pipeline prioritizing high-fidelity neural engines (WaveNet, Siri, Siri Enhanced, Google Neural) while filtering low-quality synthetic voices.
* Granular playback velocity control (0.5x to 1.5x speed multiplier).

### 1.6 Gamification and Progress Tracking
* Experience Points (XP) & Knowledge Tiers: Dynamic progression from A1 (Beginner) to C2 (Advanced).
* Daily Streaks: Tracks consecutive active daily study sessions with persistent timestamp validation.
* Hearts System: Challenge mode with 5 lives vs. Unlimited Hearts for PRO subscribers.
* Achievements & Leaderboard: Global rank tracking and performance analytics.

### 1.7 Enterprise Security and Administration
* Role-based access control (RBAC) distinguishing standard users from system administrators.
* Admin panel (`/admin`) for account management, priority customer support ticketing, system metrics, and security audit logs.
* Authenticated operations enforced server-side via BCrypt password hashing and JWT access/refresh token rotation.

---

## 2. Technical Architecture

### 2.1 Technology Stack
* Frontend Framework: Flutter Web/Desktop/Mobile (Dart 3.x)
* State Management: Riverpod 2.x (`StateNotifierProvider`, `Provider`)
* Router: GoRouter (Declarative route tree with auth-guard navigation logic)
* Local Database: Drift (SQLite) with WebAssembly (WASM) multi-threading for web clients
* Key-Value Storage: Hive for secure preference and local token caching
* Backend Server: Dart Serverpod with PostgreSQL data storage
* Payment Gateway: Stripe Checkout and Webhooks (Server-verified entitlement)

### 2.2 System Directory Structure

```text
lingu_ai/
├── assets/
│   ├── images/              # System branding, vectors, and character assets
│   └── sounds/              # Restrained UI feedback and state audio clips
├── lib/
│   ├── core/
│   │   ├── ads/             # AdMob integration logic
│   │   ├── audio/           # SoundService and TtsService implementation
│   │   ├── database/        # Drift SQLite schema definitions
│   │   ├── game_state/      # Hearts, XP, and Streak state providers
│   │   ├── network/         # Dio client, AuthInterceptor, and ApiConfig
│   │   ├── router/          # AppRouter configuration and route guards
│   │   ├── storage/         # TokenStorage and OnboardingStorage
│   │   └── widgets/         # Reusable design system components
│   ├── features/
│   │   ├── admin/           # Administrative control panel and audit metrics
│   │   ├── auth/            # AuthController, login, and registration screens
│   │   ├── home/            # Main dashboard and navigation layout
│   │   ├── learn/           # Lesson path, modules, and vocabulary views
│   │   ├── payment/         # Stripe subscription management
│   │   ├── progress/        # User profile, statistics, and support desk
│   │   ├── quiz/            # Interactive quiz controller and exercise views
│   │   ├── review/          # SM-2 spaced repetition review session
│   │   └── tutor/           # Conversational AI tutor interface
│   └── l10n/                # Localization files (app_en.arb, app_ur.arb)
├── linguai_backend/
│   └── linguai_backend_server/
│       ├── lib/
│       │   ├── src/
│       │   │   ├── generated/ # Serverpod protocol models
│       │   │   ├── services/  # Security, mail, and encryption services
│       │   │   └── web/       # REST API endpoints (api_route.dart)
│       │   └── server.dart
├── web/                     # Web deployment entry point, loader, and manifest
├── pubspec.yaml
└── README.md
```

---

## 3. Spaced Repetition (SM-2) Implementation

The spacing algorithm calculates the next review interval $I(q)$ and updated easiness factor $EF'$ based on user quality score $q \in \{0, 1, 2, 3, 4, 5\}$:

$$EF' = EF + (0.1 - (5 - q) \times (0.08 + (5 - q) \times 0.02))$$

Where:
* Minimum $EF$ threshold is constrained to $1.3$.
* For quality score $q < 3$, repetition count is reset to $0$, and interval $I = 1$ day.
* For quality score $q \ge 3$:
  * $I(1) = 1$ day
  * $I(2) = 6$ days
  * $I(n) = I(n-1) \times EF'$ for $n > 2$

---

## 4. API Specification and Authentication

All requests to `/api/v1` require Bearer Token authorization headers except public auth endpoints.

### 4.1 Authentication Endpoints
* `POST /api/v1/auth/register`: Creates new user account. Auto-verifies account in local/development mode when SMTP host is unconfigured.
* `POST /api/v1/auth/login`: Authenticates credentials, generates JWT access token and rotating refresh token.
* `GET /api/v1/auth/me`: Retrieves current authenticated user session details.
* `POST /api/v1/auth/refresh-token`: Rotates expired access token using valid refresh token.
* `POST /api/v1/auth/logout`: Invalidates active refresh token session.

### 4.2 User and Profile Endpoints
* `GET /api/v1/user/profile`: Fetches current user profile metadata.
* `PUT /api/v1/user/profile`: Updates username, avatar selection, date of birth, or target learning language.
* `POST /api/v1/user/survey`: Submits initial placement survey results (knowledge level, fluency score).

### 4.3 AI Tutor Endpoints
* `POST /api/v1/ai/tutor`: Executes conversational prompt against backend AI service for authenticated/PRO users.

### 4.4 Administrative Endpoints
* `GET /api/v1/admin/users`: Lists registered user accounts, roles, and status (Requires admin role or QA access flag).
* `PATCH /api/v1/admin/users`: Updates user status (suspend, restore, promote).
* `GET /api/v1/admin/support`: Retrieves customer support ticket inbox.

---

## 5. Environment Configuration

### 5.1 Frontend Build Definitions

```bash
flutter build web --release \
  --base-href "/lingu_ai/" \
  --dart-define=API_URL=https://your-api-domain.com/api/v1
```

### 5.2 Backend Environment Variables (`.env`)

```ini
SERVERPOD_PORT=8080
SERVERPOD_RUN_MODE=development
DATABASE_HOST=127.0.0.1
DATABASE_PORT=5432
DATABASE_NAME=linguai
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres_password
JWT_SECRET=your_secure_jwt_secret_key_here
PUBLIC_API_URL=http://localhost:3000/api/v1
PUBLIC_APP_URL=http://localhost:3000
```

---

## 6. Local Development Setup

### 6.1 Prerequisites
* Flutter SDK (3.19.0 or higher)
* Dart SDK (3.3.0 or higher)
* Docker Desktop or Podman (for local PostgreSQL database)

### 6.2 Frontend Installation and Execution
1. Clone the repository:
   ```bash
   git clone https://github.com/zaintahir2025/lingu_ai.git
   cd lingu_ai
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run local web development server:
   ```bash
   ./tool/start_local_web.sh
   ```

### 6.3 Backend Installation and Execution
1. Navigate to backend directory:
   ```bash
   cd linguai_backend/linguai_backend_server
   ```
2. Install backend dependencies:
   ```bash
   dart pub get
   ```
3. Start database and server instance:
   ```bash
   ../../tool/start_local_backend.sh
   ```

---

## 7. Deployment Strategy

### 7.1 GitHub Pages Deployment
The web bundle is compiled to HTML/CSS/WASM JS and deployed to the `gh-pages` branch using GitHub Actions or manual script compilation:

```bash
flutter build web --release --base-href "/lingu_ai/"
```

### 7.2 Containerized Backend Deployment
The Serverpod backend is packaged using standard Docker containers connected to a managed PostgreSQL cluster (e.g., AWS RDS, GCP Cloud SQL) and deployed via Docker Compose or Kubernetes.

---

## 8. License
Distributed under the MIT License. See `LICENSE` for details.
