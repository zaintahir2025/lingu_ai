import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/local_storage/local_storage_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/widgets/shared/in_app_notification_banner.dart';
import 'core/notifications/notification_service.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final box = await LocalStorageService.init();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(box),
      ],
      child: const LinguAiApp(),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class LinguAiApp extends ConsumerStatefulWidget {
  const LinguAiApp({super.key});

  @override
  ConsumerState<LinguAiApp> createState() => _LinguAiAppState();
}

class _LinguAiAppState extends ConsumerState<LinguAiApp> {
  @override
  void initState() {
    super.initState();
    // Initialize notification service once the app starts
    Future.microtask(() {
      ref.read(notificationServiceProvider).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(routerProvider);

    return InAppNotificationBanner(
      child: MaterialApp.router(
        title: 'LinguAI',
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: AppTheme.lightTheme,
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: ref.watch(localeProvider),
      ),
    );
  }
}
