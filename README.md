# LinguAI — Modern Gamified AI Language Learning App

LinguAI is a state-of-the-art, gamified language learning web and mobile application inspired by Duolingo and Anki SRS. Built with Flutter, Riverpod, Drift (SQLite), and Google Gemini AI, LinguAI provides interactive lessons, AI tutor conversations, spaced-repetition vocabulary review, native accent text-to-speech, bilingual UI localization (English and Urdu), and complete subscription management.

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
- Audio Pronunciation Speed: User-adjustable speech rate slider in Profile Settings ranging from 0.20x (Slow) to 1.00x (Fast).
- Lag-free Web SpeechSynthesis execution.

### 6. LinguAI PRO Membership and Payment Gateway
- 1-Month Subscription Pass: Grants 30 days of full access to PRO features.
- Credit / Debit Card Checkout Screen (/payment): Accepts card inputs, displays official Admin banking payout credentials, and instantly activates PRO status.
- PRO Benefits:
  - Unlimited 24/7 AI Language Tutor
  - 100% Ad-Free Experience (Suppresses AdMob banners)
  - Unlimited Hearts Mode (Infinite lives)
  - Priority Customer Support Desk

### 7. Admin Control Panel (/admin)
System administrators have complete control over app settings:
1. Registered User Accounts and Premium Control: Displays live user accounts with instant buttons to Grant or Revoke 1-Month Premium passes.
2. Priority Customer Support Inbox: View, reply to, or delete support tickets submitted by users via Contact Us. Premium member tickets are automatically sorted to the top.
3. Google AdMob Setup: Configure Banner and Interstitial Ad Unit IDs or toggle ads on/off.
4. Banking Revenue Payout Setup: Configure Admin Bank Name, Account Holder, IBAN, and SWIFT code displayed on the checkout page.

### 8. Gamification and Daily Motivation
- XP and Knowledge Levels: Earn XP from completed lessons and quizzes to advance levels (A1 Beginner, A2 Intermediate, etc.).
- Streak Counter: Tracks consecutive daily learning sessions.
- Hearts System: Challenge mode (5 hearts) vs Unlimited Hearts mode.
- Course Unenroll / Progress Reset: Switch or unenroll language courses with a clear confirmation warning modal that resets unlocked levels and review cards.

### 9. Modern Aesthetic Design and App Branding
- Mascot-inspired high-resolution app icon and favicon based directly on the green owl bot.
- Dark Royal Purple and Gold Shimmer PRO Cards with clean badges.
- Fully responsive design matching desktop, tablet, and mobile browsers.

---

## Technology Stack

- Framework: Flutter Web and Mobile (Dart 3.x)
- State Management: Riverpod 2.x (StateNotifierProvider, Provider)
- Database and Persistence:
  - Drift (SQLite) with WebAssembly (WASM) worker for browser database storage.
  - Hive key-value storage for user settings, tokens, and subscription flags.
- Routing: GoRouter
- Audio and TTS: flutter_tts with dynamic BCP-47 locale configuration.
- AI Integration: Google Gemini REST API via http.
- Localization: Flutter gen-l10n (app_en.arb, app_ur.arb).

---

## Repository Structure

```
lingu_ai/
├── assets/
├── lib/
│   ├── core/
│   │   ├── ads/                 # Google AdMob Banner and Interstitial Widgets
│   │   ├── audio/               # TtsService and Speed Rate Providers
│   │   ├── database/            # Drift SQLite VocabWords and Lessons tables
│   │   ├── game_state/          # Hearts, Streak and XP Storage
│   │   ├── router/              # AppRouter GoRouter navigation configuration
│   │   ├── storage/             # Token, Premium, Onboarding and User Registry Storage
│   │   └── widgets/             # Shared UI components and Premium badges
│   ├── features/
│   │   ├── admin/               # AdminPanelScreen (Accounts, Support, Ads, Banking)
│   │   ├── auth/                # AuthController and Authentication screens
│   │   ├── home/                # HomeScreen and Adaptive Bottom Navigation
│   │   ├── learn/               # LearnTab, VocabTranslator and Flashcards
│   │   ├── payment/             # PaymentScreen (Credit/Debit Card Checkout)
│   │   ├── progress/            # ProfileTab and ContactUsScreen
│   │   ├── quiz/                # QuizController and QuizScreen
│   │   ├── review/              # ReviewSessionScreen (SRS Spaced Repetition)
│   │   └── tutor/               # TutorScreen (Gemini AI Tutor Chat)
│   └── l10n/                    # AppLocalizations ARB translation files
├── web/                         # Web configuration, index.html, favicon and icons
├── pubspec.yaml
└── README.md
```

---

## Getting Started Locally

### Prerequisites
- Flutter SDK (v3.19 or higher)
- Dart SDK

### Installation Steps

1. Clone the Repository:
   ```bash
   git clone https://github.com/zaintahir2025/lingu_ai.git
   cd lingu_ai
   ```

2. Install Dependencies:
   ```bash
   flutter pub get
   ```

3. Run Code Generation (if modifying database schemas):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Launch Application:
   - For Web:
     ```bash
     flutter run -d chrome
     ```
   - For Desktop / Mobile:
     ```bash
     flutter run
     ```

5. Build Production Web Bundle:
   ```bash
   flutter build web --base-href "/lingu_ai/"
   ```

---

## License
Distributed under the MIT License. See LICENSE for more information.
