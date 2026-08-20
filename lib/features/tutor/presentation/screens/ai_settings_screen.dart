import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/local_storage/local_storage_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/widgets/shared/in_app_notification_banner.dart';
import '../../data/repositories/tutor_repository.dart';

final aiSettingsStorageProvider = Provider<AiSettingsStorage>((ref) {
  final box = ref.watch(localStorageProvider);
  return AiSettingsStorage(box, const FlutterSecureStorage());
});

class AiSettingsStorage {
  final Box? _boxInstance;
  final FlutterSecureStorage _secureStorage;
  static const String _providerKey = 'ai_provider';
  static const String _apiKey = 'ai_api_key';

  AiSettingsStorage(this._boxInstance, this._secureStorage);

  Box? get _box {
    if (_boxInstance != null && _boxInstance.isOpen) return _boxInstance;
    if (Hive.isBoxOpen('lingu_ai_box')) return Hive.box('lingu_ai_box');
    return null;
  }

  String get provider => 'Google Gemini API';

  Future<String> getApiKey() async {
    final secureKey = await _secureStorage.read(key: _apiKey);
    if (secureKey != null) return secureKey;

    final legacyKey = (_box?.get(_apiKey) as String?) ?? '';
    if (legacyKey.isNotEmpty) {
      await _secureStorage.write(key: _apiKey, value: legacyKey);
      await _box?.delete(_apiKey);
    }
    return legacyKey;
  }

  Future<void> saveSettings({
    required String provider,
    required String apiKey,
  }) async {
    final box = _box;
    if (box != null) {
      await box.put(_providerKey, 'Google Gemini API');
      await box.delete(_apiKey);
    }
    if (apiKey.isEmpty) {
      await _secureStorage.delete(key: _apiKey);
    } else {
      await _secureStorage.write(key: _apiKey, value: apiKey);
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
    _keyController = TextEditingController();
    _loadStoredKey();
  }

  Future<void> _loadStoredKey() async {
    final key = await ref.read(aiSettingsStorageProvider).getApiKey();
    if (mounted) _keyController.text = key;
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _saveAndTest() async {
    final key = _keyController.text.trim();
    final storage = ref.read(aiSettingsStorageProvider);

    if (key.isEmpty) {
      await storage.saveSettings(provider: 'Google Gemini API', apiKey: '');
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
    final result = await repo.validateApiKey(key);
    if (!mounted) return;
    setState(() => _isValidating = false);

    if (result.isValid) {
      await storage.saveSettings(
        provider: 'Google Gemini API',
        apiKey: key,
      );
      if (!mounted) return;
      InAppNotificationBanner.show(
        context: context,
        title: 'Gemini Key Verified! ✅',
        message: 'Your Google Gemini API Key is valid and active!',
        type: NotificationType.success,
      );
    } else {
      InAppNotificationBanner.show(
        context: context,
        title: 'Key Verification Failed',
        message:
            result.errorMessage ??
            'The key was rejected by Google Gemini. Please check your key at https://aistudio.google.com.',
        type: NotificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Google Gemini AI Settings'),
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
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.primaryGreen,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Google Gemini API Tutor: Enter your free Gemini API Key from Google AI Studio to unlock unlimited interactive AI tutoring.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryGreenDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space24),

            // Key Input
            Text(
              'Google Gemini API Key:',
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
                hintText: 'Paste key from Google AI Studio...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.key_rounded),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscureKey
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Info: Free tier available via Google AI Studio.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '🔑 Get key at: https://aistudio.google.com',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGreenDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space32),
            PrimaryButton(
              text: _isValidating ? 'Validating Key...' : 'Save & Test Gemini Key',
              onPressed: _isValidating ? null : _saveAndTest,
            ),
          ],
        ),
      ),
    );
  }
}
