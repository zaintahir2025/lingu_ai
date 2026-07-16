// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LinguAI';

  @override
  String get learnTab => 'Learn';

  @override
  String get leaderboardTab => 'Leaderboard';

  @override
  String get profileTab => 'Profile';

  @override
  String get unitLabel => 'Unit 1';

  @override
  String get unitDescription => 'Introduce yourself and greet people';

  @override
  String get continueButton => 'Continue';

  @override
  String get loginTitle => 'Log in';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loggingInLabel => 'Logging in...';

  @override
  String get noAccountRegisterLabel => 'Don\'t have an account? Register';

  @override
  String get registerTitle => 'Register';

  @override
  String get usernameLabel => 'Username';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get registeringLabel => 'Registering...';

  @override
  String get alreadyHaveAccountLabel => 'Already have an account? Log in';

  @override
  String get forgotPasswordScreen => 'Forgot Password Screen';

  @override
  String get resetPasswordScreen => 'Reset Password Screen';

  @override
  String get iWantToLearn => 'I want to learn...';

  @override
  String get englishLanguage => 'English';

  @override
  String get urduLanguage => 'Urdu';

  @override
  String get howMuchDoYouKnow => 'How much do you know?';

  @override
  String get beginnerLevel => 'I am a beginner';

  @override
  String get intermediateLevel => 'I know some words';

  @override
  String get advancedLevel => 'I can have a basic conversation';

  @override
  String get howItWorks => 'How it works';

  @override
  String get biteSizedLessons => 'Bite-sized lessons';

  @override
  String get learnEveryDay => 'Learn a little every day';

  @override
  String get earnXp => 'Earn XP';

  @override
  String get practiceMakesPerfect => 'Practice makes perfect';

  @override
  String get personalizedPlanReady => 'Your personalized plan is ready!';

  @override
  String get letsStartLearning => 'Let\'s start learning';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get nameLabel => 'Name';

  @override
  String get passwordMinLength => 'At least 8 characters';

  @override
  String get passwordContainsNumber => 'Contains a number';

  @override
  String get passwordContainsSpecialChar => 'Contains a special character';

  @override
  String get whatLanguageLearn => 'What language do you want to learn?';

  @override
  String get langSpanish => 'Spanish';

  @override
  String get langFrench => 'French';

  @override
  String get langJapanese => 'Japanese';

  @override
  String get tourLearnFastTitle => 'Learn Fast';

  @override
  String get tourLearnFastDesc => 'Interactive lessons tailored to your level.';

  @override
  String get tourTrackProgressTitle => 'Track Progress';

  @override
  String get tourTrackProgressDesc => 'Watch your skills improve over time.';

  @override
  String get tourStayMotivatedTitle => 'Stay Motivated';

  @override
  String get tourStayMotivatedDesc => 'Earn rewards and maintain your streak.';

  @override
  String get nextButton => 'Next';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String placementQuestionTitle(int num) {
    return 'Question $num';
  }

  @override
  String get placementSelectTranslation => 'Select the correct translation...';

  @override
  String placementOptionTitle(int num) {
    return 'Option $num';
  }

  @override
  String get resultsPlacedAt => 'You placed at level:';

  @override
  String get resultsIntermediateB1 => 'Intermediate (B1)';

  @override
  String get reviewTab => 'Review';

  @override
  String get tutorTab => 'Tutor';

  @override
  String get progressTab => 'Progress';

  @override
  String get progressTabComingSoon => 'Progress Tab (Coming Soon)';

  @override
  String get dailyQuests => 'Daily Quests';

  @override
  String get earn50Xp => 'Earn 50 XP';

  @override
  String get complete2Lessons => 'Complete 2 lessons';

  @override
  String get vocabularyList => 'Vocabulary List';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get weeklyXp => 'Weekly XP';

  @override
  String get statistics => 'Statistics';

  @override
  String get totalXp => 'Total XP';

  @override
  String get levelTitle => 'Level';

  @override
  String get dayStreak => 'Day Streak';

  @override
  String get masteredWords => 'Mastered Words';

  @override
  String get completedLessons => 'Completed Lessons';

  @override
  String get minutesSpent => 'Minutes Spent';

  @override
  String levelProgress(int current, int next) {
    return 'Level $current to $next';
  }

  @override
  String xpProgress(int current, int total) {
    return '$current / $total XP';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get receiveRemindersDesktop => 'Receive Reminders (while app is open)';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get getStreakReminders => 'Get streak and review reminders';

  @override
  String get dailyReview => 'Daily Review';

  @override
  String get wordsDueToday => 'Words Due Today';

  @override
  String get startReview => 'Start Review';

  @override
  String get allCaughtUp => 'You are all caught up!';

  @override
  String get activityHeatmap => 'Activity Heatmap';

  @override
  String get heatmapComingSoon => 'Heatmap (Coming Soon)';

  @override
  String get wordsMastered => 'Words Mastered:';

  @override
  String get tutorSleepingTitle => 'Tutor is Sleeping';

  @override
  String get tutorSleepingMessage =>
      'The AI Tutor is resting while you are offline. Reconnect to the internet to start chatting!';

  @override
  String get tutorIsTyping => 'Tutor is typing...';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get noVocabForLesson => 'No vocabulary found for this lesson.';

  @override
  String wordsLeft(int count) {
    return '$count words left';
  }

  @override
  String get stillLearningLeft => 'Still learning (Left)';

  @override
  String get gotItRight => 'Got it (Right)';

  @override
  String get allTab => 'All';

  @override
  String get learningTab => 'Learning';

  @override
  String get masteredTab => 'Mastered';

  @override
  String get noVocabFound => 'No vocabulary words found.';

  @override
  String get noWordsCategory => 'No words in this category.';

  @override
  String get sessionCompleteTitle => 'Session Complete';

  @override
  String get sessionCompleteHeadline => 'Session Complete!';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get ratingAgain => 'Again';

  @override
  String get ratingHard => 'Hard';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingEasy => 'Easy';

  @override
  String get ratingSubtextAgain => '< 1m';

  @override
  String get ratingSubtextNext => 'Next';

  @override
  String get tapToReveal => 'Tap card to reveal answer';

  @override
  String get unlockProTitle => 'Unlock Pro Features';

  @override
  String get unlockProDesc =>
      'Get access to the AI Tutor, personalized error analysis, and unlimited practice sessions.';

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get notificationFallbackTitle => 'Notification';

  @override
  String get offlineTitleDefault => 'You are Offline';

  @override
  String get offlineMessageDefault =>
      'Please reconnect to the internet to use this feature.';
}
