import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LinguAI'**
  String get appTitle;

  /// No description provided for @learnTab.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnTab;

  /// No description provided for @leaderboardTab.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit 1'**
  String get unitLabel;

  /// No description provided for @unitDescription.
  ///
  /// In en, this message translates to:
  /// **'Introduce yourself and greet people'**
  String get unitDescription;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loggingInLabel.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingInLabel;

  /// No description provided for @noAccountRegisterLabel.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get noAccountRegisterLabel;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @registeringLabel.
  ///
  /// In en, this message translates to:
  /// **'Registering...'**
  String get registeringLabel;

  /// No description provided for @alreadyHaveAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyHaveAccountLabel;

  /// No description provided for @forgotPasswordScreen.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password Screen'**
  String get forgotPasswordScreen;

  /// No description provided for @resetPasswordScreen.
  ///
  /// In en, this message translates to:
  /// **'Reset Password Screen'**
  String get resetPasswordScreen;

  /// No description provided for @iWantToLearn.
  ///
  /// In en, this message translates to:
  /// **'I want to learn...'**
  String get iWantToLearn;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @urduLanguage.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get urduLanguage;

  /// No description provided for @howMuchDoYouKnow.
  ///
  /// In en, this message translates to:
  /// **'How much do you know?'**
  String get howMuchDoYouKnow;

  /// No description provided for @beginnerLevel.
  ///
  /// In en, this message translates to:
  /// **'I am a beginner'**
  String get beginnerLevel;

  /// No description provided for @intermediateLevel.
  ///
  /// In en, this message translates to:
  /// **'I know some words'**
  String get intermediateLevel;

  /// No description provided for @advancedLevel.
  ///
  /// In en, this message translates to:
  /// **'I can have a basic conversation'**
  String get advancedLevel;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @biteSizedLessons.
  ///
  /// In en, this message translates to:
  /// **'Bite-sized lessons'**
  String get biteSizedLessons;

  /// No description provided for @learnEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Learn a little every day'**
  String get learnEveryDay;

  /// No description provided for @earnXp.
  ///
  /// In en, this message translates to:
  /// **'Earn XP'**
  String get earnXp;

  /// No description provided for @practiceMakesPerfect.
  ///
  /// In en, this message translates to:
  /// **'Practice makes perfect'**
  String get practiceMakesPerfect;

  /// No description provided for @personalizedPlanReady.
  ///
  /// In en, this message translates to:
  /// **'Your personalized plan is ready!'**
  String get personalizedPlanReady;

  /// No description provided for @letsStartLearning.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start learning'**
  String get letsStartLearning;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordContainsNumber.
  ///
  /// In en, this message translates to:
  /// **'Contains a number'**
  String get passwordContainsNumber;

  /// No description provided for @passwordContainsSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Contains a special character'**
  String get passwordContainsSpecialChar;

  /// No description provided for @whatLanguageLearn.
  ///
  /// In en, this message translates to:
  /// **'What language do you want to learn?'**
  String get whatLanguageLearn;

  /// No description provided for @langSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get langSpanish;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get langFrench;

  /// No description provided for @langJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get langJapanese;

  /// No description provided for @tourLearnFastTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Fast'**
  String get tourLearnFastTitle;

  /// No description provided for @tourLearnFastDesc.
  ///
  /// In en, this message translates to:
  /// **'Interactive lessons tailored to your level.'**
  String get tourLearnFastDesc;

  /// No description provided for @tourTrackProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get tourTrackProgressTitle;

  /// No description provided for @tourTrackProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch your skills improve over time.'**
  String get tourTrackProgressDesc;

  /// No description provided for @tourStayMotivatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay Motivated'**
  String get tourStayMotivatedTitle;

  /// No description provided for @tourStayMotivatedDesc.
  ///
  /// In en, this message translates to:
  /// **'Earn rewards and maintain your streak.'**
  String get tourStayMotivatedDesc;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButton;

  /// No description provided for @placementQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Question {num}'**
  String placementQuestionTitle(int num);

  /// No description provided for @placementSelectTranslation.
  ///
  /// In en, this message translates to:
  /// **'Select the correct translation...'**
  String get placementSelectTranslation;

  /// No description provided for @placementOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Option {num}'**
  String placementOptionTitle(int num);

  /// No description provided for @resultsPlacedAt.
  ///
  /// In en, this message translates to:
  /// **'You placed at level:'**
  String get resultsPlacedAt;

  /// No description provided for @resultsIntermediateB1.
  ///
  /// In en, this message translates to:
  /// **'Intermediate (B1)'**
  String get resultsIntermediateB1;

  /// No description provided for @reviewTab.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewTab;

  /// No description provided for @tutorTab.
  ///
  /// In en, this message translates to:
  /// **'Tutor'**
  String get tutorTab;

  /// No description provided for @progressTab.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTab;

  /// No description provided for @progressTabComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Progress Tab (Coming Soon)'**
  String get progressTabComingSoon;

  /// No description provided for @dailyQuests.
  ///
  /// In en, this message translates to:
  /// **'Daily Quests'**
  String get dailyQuests;

  /// No description provided for @earn50Xp.
  ///
  /// In en, this message translates to:
  /// **'Earn 50 XP'**
  String get earn50Xp;

  /// No description provided for @complete2Lessons.
  ///
  /// In en, this message translates to:
  /// **'Complete 2 lessons'**
  String get complete2Lessons;

  /// No description provided for @vocabularyList.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary List'**
  String get vocabularyList;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @weeklyXp.
  ///
  /// In en, this message translates to:
  /// **'Weekly XP'**
  String get weeklyXp;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalXp.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get totalXp;

  /// No description provided for @levelTitle.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelTitle;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @masteredWords.
  ///
  /// In en, this message translates to:
  /// **'Mastered Words'**
  String get masteredWords;

  /// No description provided for @completedLessons.
  ///
  /// In en, this message translates to:
  /// **'Completed Lessons'**
  String get completedLessons;

  /// No description provided for @minutesSpent.
  ///
  /// In en, this message translates to:
  /// **'Minutes Spent'**
  String get minutesSpent;

  /// No description provided for @levelProgress.
  ///
  /// In en, this message translates to:
  /// **'Level {current} to {next}'**
  String levelProgress(int current, int next);

  /// No description provided for @xpProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} XP'**
  String xpProgress(int current, int total);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @receiveRemindersDesktop.
  ///
  /// In en, this message translates to:
  /// **'Receive Reminders (while app is open)'**
  String get receiveRemindersDesktop;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @getStreakReminders.
  ///
  /// In en, this message translates to:
  /// **'Get streak and review reminders'**
  String get getStreakReminders;

  /// No description provided for @dailyReview.
  ///
  /// In en, this message translates to:
  /// **'Daily Review'**
  String get dailyReview;

  /// No description provided for @wordsDueToday.
  ///
  /// In en, this message translates to:
  /// **'Words Due Today'**
  String get wordsDueToday;

  /// No description provided for @startReview.
  ///
  /// In en, this message translates to:
  /// **'Start Review'**
  String get startReview;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up!'**
  String get allCaughtUp;

  /// No description provided for @activityHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Activity Heatmap'**
  String get activityHeatmap;

  /// No description provided for @heatmapComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Heatmap (Coming Soon)'**
  String get heatmapComingSoon;

  /// No description provided for @wordsMastered.
  ///
  /// In en, this message translates to:
  /// **'Words Mastered:'**
  String get wordsMastered;

  /// No description provided for @tutorSleepingTitle.
  ///
  /// In en, this message translates to:
  /// **'Tutor is Sleeping'**
  String get tutorSleepingTitle;

  /// No description provided for @tutorSleepingMessage.
  ///
  /// In en, this message translates to:
  /// **'The AI Tutor is resting while you are offline. Reconnect to the internet to start chatting!'**
  String get tutorSleepingMessage;

  /// No description provided for @tutorIsTyping.
  ///
  /// In en, this message translates to:
  /// **'Tutor is typing...'**
  String get tutorIsTyping;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @noVocabForLesson.
  ///
  /// In en, this message translates to:
  /// **'No vocabulary found for this lesson.'**
  String get noVocabForLesson;

  /// No description provided for @wordsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} words left'**
  String wordsLeft(int count);

  /// No description provided for @stillLearningLeft.
  ///
  /// In en, this message translates to:
  /// **'Still learning (Left)'**
  String get stillLearningLeft;

  /// No description provided for @gotItRight.
  ///
  /// In en, this message translates to:
  /// **'Got it (Right)'**
  String get gotItRight;

  /// No description provided for @allTab.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allTab;

  /// No description provided for @learningTab.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learningTab;

  /// No description provided for @masteredTab.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get masteredTab;

  /// No description provided for @noVocabFound.
  ///
  /// In en, this message translates to:
  /// **'No vocabulary words found.'**
  String get noVocabFound;

  /// No description provided for @noWordsCategory.
  ///
  /// In en, this message translates to:
  /// **'No words in this category.'**
  String get noWordsCategory;

  /// No description provided for @sessionCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get sessionCompleteTitle;

  /// No description provided for @sessionCompleteHeadline.
  ///
  /// In en, this message translates to:
  /// **'Session Complete!'**
  String get sessionCompleteHeadline;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @ratingAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get ratingAgain;

  /// No description provided for @ratingHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get ratingHard;

  /// No description provided for @ratingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ratingGood;

  /// No description provided for @ratingEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get ratingEasy;

  /// No description provided for @ratingSubtextAgain.
  ///
  /// In en, this message translates to:
  /// **'< 1m'**
  String get ratingSubtextAgain;

  /// No description provided for @ratingSubtextNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get ratingSubtextNext;

  /// No description provided for @tapToReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap card to reveal answer'**
  String get tapToReveal;

  /// No description provided for @unlockProTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro Features'**
  String get unlockProTitle;

  /// No description provided for @unlockProDesc.
  ///
  /// In en, this message translates to:
  /// **'Get access to the AI Tutor, personalized error analysis, and unlimited practice sessions.'**
  String get unlockProDesc;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// No description provided for @notificationFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationFallbackTitle;

  /// No description provided for @offlineTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'You are Offline'**
  String get offlineTitleDefault;

  /// No description provided for @offlineMessageDefault.
  ///
  /// In en, this message translates to:
  /// **'Please reconnect to the internet to use this feature.'**
  String get offlineMessageDefault;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
