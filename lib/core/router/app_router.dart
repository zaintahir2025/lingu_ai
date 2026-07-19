import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/learn/presentation/screens/module_flow_screen.dart';
import '../../features/review/presentation/screens/review_session_screen.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../storage/onboarding_storage.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/onboarding/presentation/screens/lang_picker_screen.dart';
import '../../features/onboarding/presentation/screens/tour_screen.dart';
import '../../features/onboarding/presentation/screens/profile_setup_screen.dart';
import '../../features/onboarding/presentation/screens/experience_choice_screen.dart';
import '../../features/onboarding/presentation/screens/survey_screen.dart';
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

      if (isInitial) {
        return null;
      }

      if (!isAuth) {
        if (!hasCompletedOnboarding) {
          if (state.matchedLocation != '/onboarding/tour' && !goingToAuth) {
             return '/onboarding/tour'; // Start with Tour
          }
        } else {
          if (!goingToAuth) return '/auth/login';
        }
      } else {
        final user = authState.user;
        if (user != null) {
          if (user.username == null) {
            if (state.matchedLocation != '/profile-setup') return '/profile-setup';
          } else if (user.targetLanguage == null) {
            if (state.matchedLocation != '/onboarding/lang') return '/onboarding/lang';
          } else if (user.knowledgeLevel == null) {
            if (state.matchedLocation != '/experience-choice' && state.matchedLocation != '/survey') return '/experience-choice';
          } else {
            if (goingToAuth || state.matchedLocation.startsWith('/onboarding') || state.matchedLocation == '/profile-setup' || state.matchedLocation == '/experience-choice' || state.matchedLocation == '/survey') {
              return '/';
            }
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/module/:lessonId',
        name: 'module',
        pageBuilder: (context, state) {
          final lessonId = int.parse(state.pathParameters['lessonId']!);
          return CustomTransitionPage(
            key: state.pageKey,
            child: ModuleFlowScreen(lessonId: lessonId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/review/session',
        name: 'review_session',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ReviewSessionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/onboarding/lang',
        name: 'lang_picker',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LangPickerScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      GoRoute(
        path: '/onboarding/tour',
        name: 'tour',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const TourScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/learn/vocabulary',
        name: 'vocabulary',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const VocabularyListScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/tutor/errors',
        name: 'tutor_errors',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PersistentErrorsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/profile-setup',
        name: 'profile_setup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ProfileSetupScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/experience-choice',
        name: 'experience_choice',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ExperienceChoiceScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/survey',
        name: 'survey',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SurveyScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );
});
