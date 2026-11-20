import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String _publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );
  static const String _legacyAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  static String get publishableKey =>
      _publishableKey.isNotEmpty ? _publishableKey : _legacyAnonKey;

  static bool get isConfigured =>
      url.startsWith('https://') && publishableKey.isNotEmpty;

  static Future<void> init() async {
    if (!isConfigured) {
      debugPrint(
        'Supabase is not configured. Set SUPABASE_URL and '
        'SUPABASE_PUBLISHABLE_KEY (or SUPABASE_ANON_KEY).',
      );
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        publishableKey: publishableKey,
        debug: kDebugMode,
      );
      debugPrint('Supabase initialized successfully.');
    } catch (error) {
      // Keep the app bootable, but authentication remains unavailable.
      debugPrint('Supabase initialization failed: $error');
    }
  }
}

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  try {
    return Supabase.instance.client;
  } catch (_) {
    return null;
  }
});
