import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/quiz/presentation/screens/quiz_screen.dart';
import '../../features/quiz/presentation/screens/quiz_results_screen.dart';
import '../../features/review/presentation/screens/review_session_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../storage/onboarding_storage.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/onboarding/presentation/screens/lang_picker_screen.dart';
import '../../features/onboarding/presentation/screens/placement_screen.dart';
import '../../features/onboarding/presentation/screens/results_screen.dart';
import '../../features/onboarding/presentation/screens/tour_screen.dart';
import '../../features/learn/presentation/screens/flashcard_screen.dart';
import '../../features/learn/presentation/screens/vocabulary_list_screen.dart';
import '../../features/tutor/presentation/screens/persistent_errors_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  final onboardingStorage = ref.watch(onboardingStorageProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final isInitial = authState.status == AuthStatus.initial;
      final hasCompletedOnboarding = onboardingStorage.hasCompletedOnboarding;
      
      final goingToAuth = state.matchedLocation.startsWith('/auth');
      final goingToOnboarding = state.matchedLocation.startsWith('/onboarding');

      if (isInitial) {
        return null;
      }

      // Save onboarding route if we are navigating inside it
      if (goingToOnboarding) {
        onboardingStorage.setLastOnboardingRoute(state.matchedLocation);
      }

      if (!isAuth) {
        if (!hasCompletedOnboarding) {
          if (!goingToOnboarding) {
            final resumeRoute = onboardingStorage.lastOnboardingRoute ?? '/onboarding/lang';
            return resumeRoute;
          }
        } else {
          if (!goingToAuth) return '/auth/login';
        }
      } else {
        if (goingToAuth || goingToOnboarding) return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/quiz/:lessonId',
        name: 'quiz',
        builder: (context, state) {
          final lessonId = int.parse(state.pathParameters['lessonId']!);
          return QuizScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/quiz/results/:lessonId',
        name: 'quiz_results',
        builder: (context, state) {
          final lessonId = int.parse(state.pathParameters['lessonId']!);
          return QuizResultsScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/review/session',
        name: 'review_session',
        builder: (context, state) => const ReviewSessionScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding/lang',
        name: 'lang_picker',
        builder: (context, state) => const LangPickerScreen(),
      ),
      GoRoute(
        path: '/onboarding/placement',
        name: 'placement',
        builder: (context, state) => const PlacementScreen(),
      ),
      GoRoute(
        path: '/onboarding/results',
        name: 'results',
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: '/onboarding/tour',
        name: 'tour',
        builder: (context, state) => const TourScreen(),
      ),
      GoRoute(
        path: '/learn/flashcards/:lessonId',
        name: 'flashcards',
        builder: (context, state) {
          final lessonId = int.parse(state.pathParameters['lessonId']!);
          return FlashcardScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '/learn/vocabulary',
        name: 'vocabulary',
        builder: (context, state) => const VocabularyListScreen(),
      ),
      GoRoute(
        path: '/tutor/errors',
        name: 'tutor_errors',
        builder: (context, state) => const PersistentErrorsScreen(),
      ),
    ],
  );
});
