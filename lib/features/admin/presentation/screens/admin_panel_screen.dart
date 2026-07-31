import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/local_storage/local_storage_provider.dart';

final adminSettingsProvider = StateNotifierProvider<AdminSettingsNotifier, AdminSettingsState>((ref) {
  final box = ref.watch(localStorageProvider);
  return AdminSettingsNotifier(box);
});

class AdminSettingsState {
  final bool adsEnabled;
  final String bannerAdUnitId;
  final String interstitialAdUnitId;
  final String bankName;
  final String accountHolderName;
  final String ibanNumber;
  final String swiftCode;
  final String payoutStatus;

  AdminSettingsState({
    required this.adsEnabled,
    required this.bannerAdUnitId,
    required this.interstitialAdUnitId,
    required this.bankName,
    required this.accountHolderName,
    required this.ibanNumber,
    required this.swiftCode,
    required this.payoutStatus,
  });

  AdminSettingsState copyWith({
    bool? adsEnabled,
    String? bannerAdUnitId,
    String? interstitialAdUnitId,
    String? bankName,
    String? accountHolderName,
    String? ibanNumber,
    String? swiftCode,
    String? payoutStatus,
  }) {
    return AdminSettingsState(
      adsEnabled: adsEnabled ?? this.adsEnabled,
      bannerAdUnitId: bannerAdUnitId ?? this.bannerAdUnitId,
      interstitialAdUnitId: interstitialAdUnitId ?? this.interstitialAdUnitId,
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      ibanNumber: ibanNumber ?? this.ibanNumber,
      swiftCode: swiftCode ?? this.swiftCode,
      payoutStatus: payoutStatus ?? this.payoutStatus,
    );
  }
}

class AdminSettingsNotifier extends StateNotifier<AdminSettingsState> {
  final dynamic _box;

  AdminSettingsNotifier(this._box)
      : super(AdminSettingsState(
          adsEnabled: _box.get('admin_ads_enabled', defaultValue: true) as bool,
          bannerAdUnitId: _box.get('admin_banner_ad_id', defaultValue: 'ca-app-pub-3940256099942544/6300978111') as String,
          interstitialAdUnitId: _box.get('admin_interstitial_ad_id', defaultValue: 'ca-app-pub-3940256099942544/1033173712') as String,
          bankName: _box.get('admin_bank_name', defaultValue: 'Global Commerce Bank') as String,
          accountHolderName: _box.get('admin_acc_holder', defaultValue: 'LinguAI Inc') as String,
          ibanNumber: _box.get('admin_iban', defaultValue: 'PK36GCB0000123456789') as String,
          swiftCode: _box.get('admin_swift', defaultValue: 'GCBKPKA') as String,
          payoutStatus: _box.get('admin_payout_status', defaultValue: 'Active • Auto Monthly Payout') as String,
        ));

  Future<void> updateSettings({
    bool? adsEnabled,
    String? bannerAdUnitId,
    String? interstitialAdUnitId,
    String? bankName,
    String? accountHolderName,
    String? ibanNumber,
    String? swiftCode,
    String? payoutStatus,
  }) async {
    state = state.copyWith(
      adsEnabled: adsEnabled,
      bannerAdUnitId: bannerAdUnitId,
      interstitialAdUnitId: interstitialAdUnitId,
      bankName: bankName,
      accountHolderName: accountHolderName,
      ibanNumber: ibanNumber,
      swiftCode: swiftCode,
      payoutStatus: payoutStatus,
    );

    if (adsEnabled != null) await _box.put('admin_ads_enabled', adsEnabled);
    if (bannerAdUnitId != null) await _box.put('admin_banner_ad_id', bannerAdUnitId);
    if (interstitialAdUnitId != null) await _box.put('admin_interstitial_ad_id', interstitialAdUnitId);
    if (bankName != null) await _box.put('admin_bank_name', bankName);
    if (accountHolderName != null) await _box.put('admin_acc_holder', accountHolderName);
    if (ibanNumber != null) await _box.put('admin_iban', ibanNumber);
    if (swiftCode != null) await _box.put('admin_swift', swiftCode);
    if (payoutStatus != null) await _box.put('admin_payout_status', payoutStatus);
  }
}

class AdminPanelScreen extends ConsumerStatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  ConsumerState<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends ConsumerState<AdminPanelScreen> {
  late TextEditingController _bannerIdController;
  late TextEditingController _interstitialIdController;
  late TextEditingController _bankNameController;
  late TextEditingController _accountHolderController;
  late TextEditingController _ibanController;
  late TextEditingController _swiftController;

  @override
  void initState() {
    super.initState();
    final adminState = ref.read(adminSettingsProvider);
    _bannerIdController = TextEditingController(text: adminState.bannerAdUnitId);
    _interstitialIdController = TextEditingController(text: adminState.interstitialAdUnitId);
    _bankNameController = TextEditingController(text: adminState.bankName);
    _accountHolderController = TextEditingController(text: adminState.accountHolderName);
    _ibanController = TextEditingController(text: adminState.ibanNumber);
    _swiftController = TextEditingController(text: adminState.swiftCode);
  }

  @override
  void dispose() {
    _bannerIdController.dispose();
    _interstitialIdController.dispose();
    _bankNameController.dispose();
    _accountHolderController.dispose();
    _ibanController.dispose();
    _swiftController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    await ref.read(adminSettingsProvider.notifier).updateSettings(
      bannerAdUnitId: _bannerIdController.text.trim(),
      interstitialAdUnitId: _interstitialIdController.text.trim(),
      bankName: _bankNameController.text.trim(),
      accountHolderName: _accountHolderController.text.trim(),
      ibanNumber: _ibanController.text.trim(),
      swiftCode: _swiftController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Admin Settings & Banking Setup Saved Successfully!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel • Ads & Banking Setup'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryGreen, AppColors.streakOrange],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.admin_panel_settings_rounded, size: 40, color: Colors.white),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LinguAI System Administration',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              'Configure Google AdMob Monetization & Banking Payout Accounts',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // SECTION 1: Google Ads Configuration
                const Text(
                  '1. Google Ads (AdMob) Setup 📢',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Enable In-App Ads', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Monetize app sessions with Google AdMob banners and reward ads.'),
                        value: adminState.adsEnabled,
                        activeThumbColor: AppColors.primaryGreen,
                        onChanged: (val) {
                          ref.read(adminSettingsProvider.notifier).updateSettings(adsEnabled: val);
                        },
                      ),
                      const Divider(height: 24),
                      TextField(
                        controller: _bannerIdController,
                        decoration: const InputDecoration(
                          labelText: 'Banner Ad Unit ID',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.ad_units_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _interstitialIdController,
                        decoration: const InputDecoration(
                          labelText: 'Interstitial / Rewarded Ad Unit ID',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.ads_click_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // SECTION 2: Banking & Payout Setup
                const Text(
                  '2. Banking & Revenue Payout Setup 🏦',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _bankNameController,
                        decoration: const InputDecoration(
                          labelText: 'Bank Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.account_balance_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _accountHolderController,
                        decoration: const InputDecoration(
                          labelText: 'Account Holder Name / Entity',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _ibanController,
                        decoration: const InputDecoration(
                          labelText: 'IBAN / Account Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.credit_card_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _swiftController,
                        decoration: const InputDecoration(
                          labelText: 'SWIFT / BIC Code',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.swap_vertical_circle_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.verified_rounded, color: AppColors.primaryGreen, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Payout Status: ${adminState.payoutStatus}',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryGreenDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save Admin Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    onPressed: _saveSettings,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
