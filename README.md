# LinguAI 🌍

LinguAI is an intelligent, cross-platform language learning application built with **Flutter** and **Node.js**. It combines modern interactive learning techniques—like gamified lesson paths, swipeable flashcards, and spaced repetition—with an **AI-powered Tutor** (backed by Google Gemini) to provide a deeply personalized language learning experience.

![GitHub Pages Demo](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-success?style=for-the-badge&logo=github)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)

---

## ✨ Features

### 🎓 Interactive Learning
*   **Gamified Lesson Paths**: Navigate through a visual tree of modules and unlock new lessons as you progress.
*   **Swipeable Flashcards**: Learn vocabulary through an intuitive, Tinder-style swipeable card interface.
*   **Spaced Repetition Review**: Smart review sessions that bring back words you struggled with previously.

### 🤖 AI-Powered Tutor
*   **Conversational Practice**: Chat with a friendly, intelligent language tutor powered by the **Google Gemini API**.
*   **Context-Aware Corrections**: The AI knows your target language, current fluency score, and recently failed vocabulary to tailor its responses.
*   *(Premium Feature)* Fully integrated into a paywall/subscription system for monetization.

### 🎮 Gamification & Progress Tracking
*   **Achievements & Streaks**: Earn XP, build daily streaks, and unlock achievements to stay motivated.
*   **Live Leaderboards**: Compete with other learners globally.
*   **Detailed Analytics**: Track your fluency score and module completion rates from your Profile dashboard.

### 🔐 Authentication & Onboarding
*   **Custom JWT Authentication**: Secure Email/Password registration and login powered by a Node.js backend.
*   **GitHub Pages Demo Mode**: Automatically bypasses the backend on GitHub Pages deployments to allow seamless UI exploration for portfolio demonstrations!
*   **Comprehensive Onboarding**: Guides new users through language selection, experience level assessment, and a personalized learning survey.

---

## 🏗 Architecture

The project is split into two main parts:

### 📱 Frontend (Flutter)
Built using the `flutter_riverpod` state management library and GoRouter for declarative routing.
*   **`lib/features/`**: Feature-first architecture containing Auth, Home, Learn, Onboarding, Progress, Quiz, Review, Tutor, and User domains.
*   **`lib/core/`**: Shared utilities, network configuration (Dio interceptors), theme definitions, and storage management.

### ⚙️ Backend (Node.js / Express)
A robust REST API providing authentication, AI integration, and user state management.
*   **Prisma ORM**: Type-safe database access (configured for SQLite in development).
*   **Controllers**: Modular routing for `/auth`, `/user`, and `/ai`.
*   **Google Generative AI SDK**: Direct integration with Gemini 1.5 Flash.
*   **End-to-End Encryption (E2EE)**: Custom middleware ensures secure data payloads.

---

## 🚀 Running Locally

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable)
*   [Node.js](https://nodejs.org/) (v18+)
*   [Git](https://git-scm.com/)

### 1. Start the Backend
```bash
cd backend
npm install
# Configure your .env file with your GEMINI_API_KEY and JWT_SECRET
npx prisma generate
npx prisma db push
npm run dev
```
*The backend will run on `http://localhost:3000`.*

### 2. Run the Flutter App
Open a new terminal window at the project root:
```bash
flutter pub get
# Run on Web, iOS, Android, macOS, or Windows
flutter run -d chrome
```

---

## 🌐 Deployment (GitHub Pages)

This repository includes a fully automated **GitHub Actions** CI/CD pipeline (`.github/workflows/gh-pages.yml`).

Every time code is pushed to the `main` branch:
1. The workflow builds the Flutter Web application.
2. It completely orphans and wipes the `gh-pages` branch to prevent caching issues.
3. It force-pushes the newly compiled frontend.
4. **Demo Mode**: The frontend detects it's running on GitHub Pages and automatically switches to a "Mock User" mode, allowing visitors to explore the app UI perfectly even without a live backend server.

### Live URL
Access the live version of the app at:
**[https://zaintahir2025.github.io/lingu_ai/](https://zaintahir2025.github.io/lingu_ai/)**

---

## 🛠 Tech Stack Summary
*   **Framework**: Flutter (Dart)
*   **State Management**: Riverpod (`flutter_riverpod`)
*   **Routing**: `go_router`
*   **Networking**: Dio
*   **Backend Server**: Node.js, Express.js, TypeScript
*   **Database ORM**: Prisma
*   **AI Engine**: Google Gemini (1.5-flash)
*   **CI/CD**: GitHub Actions
