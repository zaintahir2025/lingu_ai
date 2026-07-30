# LinguAI 🚀

[![Live Demo](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-brightgreen?style=for-the-badge&logo=github)](https://zaintahir2025.github.io/lingu_ai/)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

**LinguAI** is a premium, feature-rich, cross-platform language learning application built with **Flutter**, **Riverpod**, **Drift (SQLite)**, and **Node.js**. It combines proven gamification mechanics—such as Duolingo-style learning paths, swipeable flashcard queues, spaced repetition (SM-2 algorithm), and heart/streak multipliers—with a **Multi-Brain AI Tutor** (Gemini, OpenAI GPT-4o, Claude, Groq) to deliver a 5-star language learning experience.

🌐 **Live Demo**: [https://zaintahir2025.github.io/lingu_ai/](https://zaintahir2025.github.io/lingu_ai/)  
📦 **GitHub Repository**: [https://github.com/zaintahir2025/lingu_ai](https://github.com/zaintahir2025/lingu_ai)

---

## 🌟 Comprehensive Feature Overview

### 📚 1. Gamified Learning Path
- **15 CEFR-Aligned Modules**: Structured curriculum spanning Beginner (`A1`), Elementary (`A2`), Intermediate (`B1`), and Upper-Intermediate (`B2`).
- **Zig-Zag Tree Map**: Duolingo-inspired path with dynamic node states (Completed, Current/Active, Locked).
- **Interactive Mascot**: Animated Lingu mascot accompanying learners along the progression path.
- **Dynamic Header Counters**: Real-time persisted tracking of Hearts (❤️), Streak Flames (🔥), and XP Badges (⚡).

---

### 🎴 2. 3-Stage Module Learning Flow
Each lesson is organized into a progressive 3-stage mastery experience:
1. **Stage 1: Flashcards Deck**:
   - **20 Vocabulary Cards** per lesson.
   - **Queue Mechanics**: Tap `Done` to clear a card, or `Not Done` (red button / left swipe) to re-queue difficult words to the back of the deck until fully mastered.
   - **Keyboard Shortcuts**: Arrow keys (Right = Done, Left = Not Done, Space/Up = Flip card).
2. **Stage 2: Word Matching Exercise**:
   - Tap-to-pair target words with their exact meanings before quiz writing.
   - Instant audio feedback and visual color coding.
3. **Stage 3: Comprehensive Lesson Quiz**:
   - Multiple Choice, Fill-in-the-Blanks, Sentence Order, and Audio Listening questions.
   - **80% Passing Threshold**: Scoreboard circular progress indicator unlocks the next lesson only on achieving 80%+.

---

### ❤️ 3. Heart System & Game Mechanics
- **5-Heart Maximum**: Wrong quiz answers deduct a heart in real time.
- **Out of Hearts Enforcement**: When hearts hit 0, quiz interaction pauses with a modal allowing instant refill (5 ❤️) or exit.
- **Streak & XP Multipliers**: Daily streaks apply up to a **3x XP multiplier** for continuous learning.

---

### 🗣️ 4. Native Multilingual Text-To-Speech (TTS)
- Clear BCP-47 voiceovers sanitized of markdown symbols:
  - 🇪🇸 Spanish (`es-ES`)
  - 🇫🇷 French (`fr-FR`)
  - 🇩🇪 German (`de-DE`)
  - 🇯🇵 Japanese (`ja-JP`)
  - 🇵🇰 Urdu (`ur-PK`)
  - 🇬🇧 English (`en-US`)

---

### 🤖 5. Multi-Brain AI Tutor (BYOK)
- **Bring Your Own Key (BYOK)**: Select your preferred AI Engine:
  - **Google Gemini 1.5 Flash** (Default)
  - **OpenAI GPT-4o**
  - **Anthropic Claude 3.5 Sonnet**
  - **Groq Llama 3**
- **Context-Aware Assistance**: Automatically feeds weak vocabulary words and user progress into AI context for personalized grammar explanations.
- **Direct "Ask Tutor Why"**: Tap from quiz answer feedback straight into an AI explanation session.

---

### 🧠 6. Spaced Repetition System (SRS)
- **SM-2 Algorithm**: Science-backed review engine calculating interval days, repetitions, and easiness factors.
- **Quiz Weak Word Logging**: Wrong quiz answers automatically lower word ease factors and flag them for immediate review in the **Daily Review** tab.
- **Review Session Ratings**: Rate recalled items (`Again`, `Hard`, `Good`, `Easy`) to dynamically reschedule next review dates.

---

### 📊 7. Analytics & Leaderboards
- **Weekly XP Bar Chart**: Visual bar chart tracking XP earned over the last 7 days.
- **Live Leaderboard**: Cross-platform ranking list with dynamic XP sorting.
- **Profile Dashboard**: User avatars, enrolled course management (switch/unenroll), dynamic CEFR badges, and notification toggles.

---

### 🌐 8. Localization & Responsive Layout
- **Full English & Urdu Support**: Seamless interface language toggle.
- **Responsive Layout**: Adapts between desktop side-navigation rails and mobile bottom-bar navigation.

---

### 📬 9. Contact Us & Support
- Built-in feedback modal allowing users to submit bug reports, feature requests, and complaints.

---

## 🏗️ Architecture & Codebase Structure

```
lib/
├── core/
│   ├── audio/              # TTS service & sound effects
│   ├── database/           # Drift SQLite database (tables, schema)
│   ├── game_state/         # Persisted hearts, XP, and streak notifier
│   ├── local_storage/      # Hive box storage provider
│   ├── network/            # Dio client & API config
│   ├── router/             # GoRouter navigation & auth redirects
│   ├── srs/                # SM-2 Spaced Repetition algorithm
│   ├── storage/            # Onboarding & token storage
│   └── theme/              # Color palettes, typography & constants
│
├── features/
│   ├── auth/               # Login & Register controllers & screens
│   ├── home/               # Navigation scaffold & shell
│   ├── learn/              # Lesson path, flashcards, module flow
│   ├── onboarding/         # Tour, language picker, placement test
│   ├── progress/           # Profile, analytics, leaderboard, contact us
│   ├── quiz/               # Quiz controller, question views, scoreboard
│   ├── review/             # Daily review tab & SM-2 session
│   ├── tutor/              # AI Tutor, BYOK settings & paywall
│   └── user/               # User repository & data models
```

---

## 💻 Running Locally

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.19+)
- [Node.js](https://nodejs.org/) (v18+)

### 1. Run the Flutter App
```bash
# Clone the repository
git clone https://github.com/zaintahir2025/lingu_ai.git
cd lingu_ai

# Install dependencies
flutter pub get

# Run on Chrome Web, Desktop, or Mobile
flutter run -d chrome
```

### 2. (Optional) Run Backend Server
```bash
cd server
npm install
npx prisma db push
npm run dev
```

---

## 🚀 CI/CD & Deployment

This project uses **GitHub Actions** (`.github/workflows/deploy.yml`) to automatically compile and deploy the Flutter Web release to **GitHub Pages** whenever changes are pushed to `main`.

Live URL: **[https://zaintahir2025.github.io/lingu_ai/](https://zaintahir2025.github.io/lingu_ai/)**

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for details.
