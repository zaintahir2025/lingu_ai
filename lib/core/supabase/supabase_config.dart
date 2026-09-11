import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://fpilwagdoodgdwgglgxf.supabase.co',
  );

  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_p0Gu1RnE7p_vJSwVf5YRdA_wFaTUReE',
  );

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;

  static Future<void> init() async {
    try {
      await Supabase.initialize(
        url: url,
        publishableKey: publishableKey,
        debug: kDebugMode,
      );
      debugPrint('Supabase initialized successfully.');
    } catch (e) {
      debugPrint('Supabase initialization skipped/failed: $e');
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
