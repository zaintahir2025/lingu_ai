import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/local_storage/local_storage_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/widgets/shared/in_app_notification_banner.dart';
import '../../data/repositories/tutor_repository.dart';

final aiSettingsStorageProvider = Provider<AiSettingsStorage>((ref) {
  final box = ref.watch(localStorageProvider);
  return AiSettingsStorage(box);
});

class AiSettingsStorage {
  final Box? _boxInstance;
  static const String _providerKey = 'ai_provider';
  static const String _apiKey = 'ai_api_key';

  AiSettingsStorage([this._boxInstance]);

  Box? get _box {
    if (_boxInstance != null && _boxInstance.isOpen) return _boxInstance;
    if (Hive.isBoxOpen('lingu_ai_box')) return Hive.box('lingu_ai_box');
    return null;
  }

  String get provider => (_box?.get(_providerKey, defaultValue: 'Google Gemini API') as String?) ?? 'Google Gemini API';
  String get customKey => (_box?.get(_apiKey, defaultValue: '') as String?) ?? '';

  Future<void> saveSettings({required String provider, required String apiKey}) async {
    final box = _box;
    if (box != null) {
      await box.put(_providerKey, provider);
      await box.put(_apiKey, apiKey);
    }
  }
}

class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  late TextEditingController _keyController;
  bool _obscureKey = true;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    final storage = ref.read(aiSettingsStorageProvider);
    _keyController = TextEditingController(text: storage.customKey);
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _saveAndTest() async {
    final key = _keyController.text.trim();
    final storage = ref.read(aiSettingsStorageProvider);
    await storage.saveSettings(
      provider: 'Google Gemini API',
      apiKey: key,
    );

    if (key.isEmpty) {
      if (mounted) {
        InAppNotificationBanner.show(
          context: context,
          title: 'Settings Saved',
          message: 'Using built-in smart offline AI tutor engine.',
          type: NotificationType.success,
        );
      }
      return;
    }

    setState(() => _isValidating = true);
    final repo = ref.read(tutorRepositoryProvider);
    final isValid = await repo.validateGeminiApiKey(key);
    setState(() => _isValidating = false);

    if (mounted) {
      if (isValid) {
        InAppNotificationBanner.show(
          context: context,
          title: 'API Key Verified! ✅',
          message: 'Your Google Gemini API Key is valid and active!',
          type: NotificationType.success,
        );
      } else {
        InAppNotificationBanner.show(
          context: context,
          title: 'Invalid API Key ⚠️',
          message: 'Key rejected by Google AI Studio. Gemini keys usually start with "AIzaSy...". Saved settings anyway.',
          type: NotificationType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Google Gemini API Key'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: AppColors.primaryGreen, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Use your own Gemini API Key from Google AI Studio to get fast, unlimited AI tutor conversations!',
                      style: TextStyle(fontSize: 13, color: AppColors.primaryGreenDark, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space24),
            Text(
              'Google Gemini API Key (Google AI Studio)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _keyController,
              obscureText: _obscureKey,
              decoration: InputDecoration(
                hintText: 'Paste your Gemini API key (e.g. AIzaSy...)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.key_rounded),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_obscureKey ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                      onPressed: () {
                        setState(() {
                          _obscureKey = !_obscureKey;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () => _keyController.clear(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Get a free API key from Google AI Studio (aistudio.google.com). Gemini keys start with "AIzaSy...". If left blank, the app will fall back to the built-in smart AI tutor engine.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: AppConstants.space32),
            PrimaryButton(
              text: _isValidating ? 'Validating Key...' : 'Save & Test Gemini API Key',
              onPressed: _isValidating ? null : _saveAndTest,
            ),
          ],
        ),
      ),
    );
  }
}


