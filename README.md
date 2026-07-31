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
- **Dual-Mode TTS & Sentence Audio**: Interactive audio buttons pronounced via native TTS engines for single words as well as full conversational sentences.
- **Previous Card Deck Navigation**: Stack-based history navigation enabling learners to move backward and review previous cards in active decks.

### 2. Multi-Brain AI Tutor & BYOK Templates
- **BYOK Multi-Provider Engine**: Supports custom keys for **Google Gemini**, **Groq (Llama 3.3)**, **OpenAI (GPT-4o)**, and **Anthropic (Claude 3.5)** with step-by-step key format templates.
- **Built-in Smart Offline Engine**: Local AI engine fallback providing uninterrupted practice even when offline or unconfigured.

### 3. Duolingo-Style Streak Clone & Dynamic Gamification
- **Animated Streak Flame**: Duolingo-style fire flame badge with a Mon-Sun weekly activity calendar and streak freeze shields.
- **Dynamic XP & Hearts**: Live updating XP progress, customizable study goals, and unlimited hearts beginner mode.

### 4. Admin Panel • Google Ads & Banking Setup
- **Monetization & AdMob Management**: Dedicated System Admin Panel to configure Google AdMob Banner Unit IDs, Interstitial IDs, and enable/disable ads.
- **Banking Payout Setup**: Admin panel configuration for Bank Name, IBAN/Account Numbers, SWIFT codes, and monthly payout tracking.

### 5. Multi-Language Support & Course Switching
- **Native Multi-Language Decks**: Native vocabulary decks for Spanish 🇪🇸, French 🇫🇷, Japanese 🇯🇵, German 🇩🇪, and Urdu 🇵🇰.
- **Course Switch Reset Warning**: Confirmation popup warning learners before switching courses and resetting module progress cleanly in SQLite database.

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
