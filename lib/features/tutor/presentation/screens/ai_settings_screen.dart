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

  String get provider =>
      (_box?.get(_providerKey, defaultValue: 'Google Gemini API') as String?) ??
      'Google Gemini API';
  Future<String> getApiKey() async {
    final secureKey = await _secureStorage.read(key: _apiKey);
    if (secureKey != null) return secureKey;

    // One-time migration from legacy Hive storage into encrypted storage.
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
      await box.put(_providerKey, provider);
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
  late String _selectedProvider;
  bool _obscureKey = true;
  bool _isValidating = false;

  final Map<String, Map<String, String>> _providerTemplates = {
    'Google Gemini API': {
      'prefix': 'AIzaSy',
      'url': 'https://aistudio.google.com',
      'hint': 'Paste your Gemini API key (e.g. AIzaSy...)',
      'info': 'Free Tier available via Google AI Studio.',
    },
    'Groq API (Llama 3.3)': {
      'prefix': 'gsk_',
      'url': 'https://console.groq.com',
      'hint': 'Paste your Groq API key (e.g. gsk_...)',
      'info': 'Ultra-fast Llama 3.3 inference engine.',
    },
    'OpenAI / OpenRouter API': {
      'prefix': 'sk-',
      'url': 'https://platform.openai.com',
      'hint': 'Paste your OpenAI/OpenRouter key (e.g. sk-...)',
      'info': 'Supports GPT-4o-mini & OpenRouter endpoints.',
    },
  };

  @override
  void initState() {
    super.initState();
    final storage = ref.read(aiSettingsStorageProvider);
    _keyController = TextEditingController();
    _selectedProvider = storage.provider.isNotEmpty
        ? storage.provider
        : 'Google Gemini API';
    if (!_providerTemplates.containsKey(_selectedProvider)) {
      _selectedProvider = 'Google Gemini API';
    }
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
      await storage.saveSettings(provider: _selectedProvider, apiKey: '');
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
    final result = await repo.validateApiKey(
      key,
      provider: _selectedProvider,
    );
    if (!mounted) return;
    setState(() => _isValidating = false);

    if (result.isValid) {
      await storage.saveSettings(provider: _selectedProvider, apiKey: key);
      if (!mounted) return;
      InAppNotificationBanner.show(
        context: context,
        title: 'API Key Verified! ✅',
        message: 'Your $_selectedProvider Key is valid and active!',
        type: NotificationType.success,
      );
    } else {
      if (result.suggestedProvider != null) {
        setState(() {
          _selectedProvider = result.suggestedProvider!;
        });
      }
      InAppNotificationBanner.show(
        context: context,
        title: 'Key Verification Failed',
        message:
            result.errorMessage ??
            'The key was rejected by the provider. Please verify your key and try again.',
        type: NotificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final template =
        _providerTemplates[_selectedProvider] ??
        _providerTemplates['Google Gemini API']!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Brain & BYOK Settings'),
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
                      'Bring Your Own Key (BYOK): securely connect Gemini, Groq, or OpenAI for personalized tutoring. The key stays encrypted on this device.',
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

            // Select AI Provider
            const Text(
              'Select AI Engine Provider:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedProvider,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: _providerTemplates.keys.map((provider) {
                return DropdownMenuItem(
                  value: provider,
                  child: Text(
                    provider,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedProvider = val;
                  });
                }
              },
            ),
            const SizedBox(height: AppConstants.space24),

            // Key Input
            Text(
              '$_selectedProvider Key:',
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
                hintText: template['hint'],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Info: ${template['info']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '🔑 Get key at: ${template['url']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGreenDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Key prefix format: "${template['prefix']}"',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space32),
            PrimaryButton(
              text: _isValidating ? 'Validating Key...' : 'Save & Test AI Key',
              onPressed: _isValidating ? null : _saveAndTest,
            ),
          ],
        ),
      ),
    );
  }
}
