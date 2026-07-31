# LinguAI

[![Live Demo](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-brightgreen?style=for-the-badge&logo=github)](https://zaintahir2025.github.io/lingu_ai/)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

**LinguAI** is a comprehensive, production-ready, cross-platform language learning application engineered with **Flutter**, **Riverpod**, **Drift (SQLite)**, and **Node.js**. Designed specifically for absolute beginners to achieve professional language fluency, LinguAI combines structured CEFR-aligned learning modules, swipeable flashcards, spaced repetition memory algorithms, and a Multi-Brain AI Tutor supporting interactive character companions.

- **Live Application Demo**: [https://zaintahir2025.github.io/lingu_ai/](https://zaintahir2025.github.io/lingu_ai/)
- **Repository Link**: [https://github.com/zaintahir2025/lingu_ai](https://github.com/zaintahir2025/lingu_ai)

---

## Technical Features & Core Capabilities

### 1. Beginner-Friendly Curriculum & Flashcards
- **15 CEFR-Aligned Modules**: Comprehensive curriculum spanning A1 (Beginner), A2 (Elementary), B1 (Intermediate), and B2 (Upper-Intermediate).
- **330+ Contextual Flashcards**: Over 20 to 25 vocabulary cards per lesson containing target vocabulary words alongside practical, everyday conversational sentences with English translations.
- **Swipeable Queue Mechanics**: Keyboard-supported flashcards allowing card flips and re-queueing of unmastered items to the back of the deck.

### 2. Native Dual-Language Text-to-Speech (TTS)
- **Zero-Lag Execution**: Asynchronous audio pipeline eliminating main-thread UI stuttering during voice playback.
- **Contextual Language Routing**: English translations and prompts are spoken using native English (`en-US`), while target vocabulary words and sentences are rendered using proper target BCP-47 voice tags (`es-ES`, `fr-FR`, `ja-JP`, `ur-PK`, `de-DE`).

### 3. Multi-Brain AI Tutor & Interactive Character Companions
- **6 Fun Character Companions**: Switch between distinct AI companions:
  - **Lingu Owl**: Master Language Coach
  - **Professor Bear**: Linguistics & Grammar Guru
  - **Viktor Robot**: Vocabulary Speedster
  - **Zari Explorer**: Casual Conversation Buddy
  - **Junior**: Beginner Helper
  - **Detective Lucy**: Practical Scenario & Context Solver
- **Multi-Provider BYOK (Bring Your Own Key)**: Connect custom API keys for Groq (Llama 3.3), Google Gemini, OpenAI GPT-4o, or Anthropic Claude.
- **Built-in Smart Offline Engine**: Includes a resilient local AI engine ensuring uninterrupted conversations when offline or when API keys are unconfigured.

### 4. Customizable Study Duration Goals & Hearts System
- **Flexible Duration Goals**: Select Daily (10m, 15m, 30m, 45m), Weekly (1h, 2h, 4h, 7h), and Monthly (5h, 10h, 20h, 30h) study duration goals in Profile settings.
- **Beginner Unlimited Hearts Mode**: Default mode allows learners to make mistakes continuously without app-blocking paywalls.
- **Perfect Score Bonus**: Flawless quiz completions award a +50 Bonus XP multiplier.

### 5. Spaced Repetition System (SRS) & Analytics
- **SM-2 Memory Engine**: Algorithm calculating review intervals and easiness factors based on past recall performance.
- **Weak Word Logging**: Automatically identifies weak vocabulary during quizzes and routes them into the Daily Review queue.
- **Analytics & Leaderboard**: Weekly XP bar charts, streak tracking, and live ranking leaderboards.

---

## Project Architecture

```
lib/
├── core/
│   ├── audio/              # TTS service & sound managers
│   ├── database/           # Drift SQLite database schema & migrations
│   ├── game_state/         # Heart settings & XP providers
│   ├── network/            # Connectivity monitoring & Dio HTTP client
│   ├── responsive/         # Adaptive desktop rail & mobile navigation
│   └── storage/            # Local Hive storage providers
├── features/
│   ├── home/               # Primary layout & tab manager
│   ├── learn/              # Curriculum path, 330+ flashcards, & module flow
│   ├── onboarding/         # Setup, placement test, & duration goals
│   ├── progress/           # Profile dashboard, XP charts, & settings
│   ├── quiz/               # Interactive exercises & passing scoreboards
│   ├── review/             # Spaced Repetition (SM-2) review queue
│   ├── tutor/              # Character companions & Multi-Brain AI Tutor
│   └── user/               # User state management
└── main.dart               # Entry point
```

---

## Local Setup & Installation Guide

### Prerequisites
- **Flutter SDK**: `^3.11.1` or newer
- **Dart SDK**: Included with Flutter
- **Node.js**: `^18.0.0` (for backend server)

### 1. Clone Repository
```bash
git clone https://github.com/zaintahir2025/lingu_ai.git
cd lingu_ai
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run Drift Build Runner (Database Generation)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run Application
```bash
# Web
flutter run -d chrome

# Windows Desktop
flutter run -d windows
```

---

## Web Deployment Guide (GitHub Pages)

To build and publish the release bundle to GitHub Pages:

```bash
# 1. Build release web bundle with repository base-href
flutter build web --release --base-href "/lingu_ai/"

# 2. Deploy contents of build/web to gh-pages branch
npx gh-pages -d build/web
```

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
