import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/local_storage/local_storage_provider.dart';

import 'core/widgets/shared/in_app_notification_banner.dart';
import 'core/notifications/notification_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SQLite Drift Database
  // await DatabaseHelper.instance.database;

  final box = await LocalStorageService.init();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    const androidAdUnit = String.fromEnvironment('ADMOB_ANDROID_BANNER_ID');
    const iosAdUnit = String.fromEnvironment('ADMOB_IOS_BANNER_ID');
    final configured =
        !kReleaseMode ||
        (defaultTargetPlatform == TargetPlatform.android
            ? androidAdUnit.isNotEmpty
            : iosAdUnit.isNotEmpty);
    if (configured) await MobileAds.instance.initialize();
  }

  runApp(
    ProviderScope(
      overrides: [localStorageProvider.overrideWithValue(box)],
      child: const LinguAiApp(),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

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

    return MaterialApp.router(
      title: 'LinguAI',
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeProvider),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return InAppNotificationBanner(key: inAppBannerKey, child: child);
      },
    );
  }
}
