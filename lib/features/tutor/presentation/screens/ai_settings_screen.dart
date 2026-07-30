import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/local_storage/local_storage_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/widgets/shared/in_app_notification_banner.dart';

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

  String get provider => (_box?.get(_providerKey, defaultValue: 'Groq (Default Llama 3.3)') as String?) ?? 'Groq (Default Llama 3.3)';
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
  late String _selectedProvider;
  bool _obscureKey = false;

  final List<String> _providers = const [
    'Groq (Default Llama 3.3)',
    'Google Gemini 2.5 Flash',
    'OpenAI GPT-4o',
    'Anthropic Claude 3.5 Sonnet',
  ];

  @override
  void initState() {
    super.initState();
    final storage = ref.read(aiSettingsStorageProvider);
    _selectedProvider = storage.provider;
    _keyController = TextEditingController(text: storage.customKey);
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _save() async {
    final storage = ref.read(aiSettingsStorageProvider);
    await storage.saveSettings(
      provider: _selectedProvider,
      apiKey: _keyController.text.trim(),
    );

    if (mounted) {
      InAppNotificationBanner.show(
        context: context,
        title: 'Settings Saved',
        message: 'Your custom AI provider & key have been updated successfully!',
        type: NotificationType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bring Your Own AI Key (BYOK)'),
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
                  Icon(Icons.key_rounded, color: AppColors.primaryGreen, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Use your own AI Key to get unlimited AI tutor conversations and eliminate server rate limits!',
                      style: TextStyle(fontSize: 13, color: AppColors.primaryGreenDark, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.space24),
            Text(
              'Select AI Brain Provider',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedProvider,
                  isExpanded: true,
                  items: _providers.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(p),
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
              ),
            ),
            const SizedBox(height: AppConstants.space24),
            Text(
              'Your Custom API Key (Optional)',
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
                hintText: 'Paste your API key (e.g. gsk_... or AIzaSy...)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock_outline_rounded),
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
            const SizedBox(height: 8),
            const Text(
              'If left blank, the app will use default template keys.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppConstants.space32),
            PrimaryButton(
              text: 'Save AI Key Settings',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
