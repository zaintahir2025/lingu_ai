import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/local_storage/local_storage_provider.dart';
import '../../../../core/storage/premium_storage.dart';
import '../../../../core/storage/user_registry_storage.dart';
import '../../../../core/storage/support_messages_storage.dart';
import '../../../../core/widgets/shared/premium_badge.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

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

  void _showReplyDialog(SupportTicket ticket) {
    final replyController = TextEditingController(text: ticket.reply ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.reply_rounded, color: AppColors.primaryGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Reply to ${ticket.username}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ticket: ${ticket.subject}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text('Message: "${ticket.message}"', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              controller: replyController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Admin Reply Message',
                border: OutlineInputBorder(),
                hintText: 'Type your official response here...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final text = replyController.text.trim();
              if (text.isNotEmpty) {
                await ref.read(supportMessagesStorageProvider).replyMessage(ticket.id, text);
                setState(() {});
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Send Reply', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminSettingsProvider);
    final authUser = ref.watch(authControllerProvider).user;
    final isPremiumActive = ref.watch(premiumStorageProvider);
    final userRegistry = ref.watch(userRegistryStorageProvider);
    final supportStorage = ref.watch(supportMessagesStorageProvider);

    var registeredUsers = userRegistry.getAllUsers();
    if (registeredUsers.isEmpty && authUser != null) {
      final activeAcc = RegisteredUserAccount(
        id: authUser.id,
        email: authUser.email,
        username: authUser.username ?? authUser.name ?? 'Learner',
        registeredAt: '2026-08-01',
        isPremium: isPremiumActive,
      );
      userRegistry.registerOrUpdateUser(activeAcc);
      registeredUsers = [activeAcc];
    }

    final tickets = supportStorage.getAllMessages();

    // Priority Sort: Premium tickets appear FIRST at the top
    tickets.sort((a, b) {
      if (a.isPremium && !b.isPremium) return -1;
      if (!a.isPremium && b.isPremium) return 1;
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel • System Control'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
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
                              'Manage Registered Accounts, Banking Accounts, Premium Access & Support Tickets',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // SECTION 1: Registered Accounts & Premium Access Control
                const Text(
                  '1. Registered User Accounts & Premium Control 👥',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: registeredUsers.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('No registered user accounts found.')),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: registeredUsers.length,
                          separatorBuilder: (context, index) => const Divider(height: 20),
                          itemBuilder: (context, index) {
                            final user = registeredUsers[index];
                            final isThisUserPremium = user.email.toLowerCase() == authUser?.email.toLowerCase()
                                ? isPremiumActive
                                : user.isPremium;

                            return Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: isThisUserPremium ? Colors.amber.shade100 : AppColors.primaryGreen.withValues(alpha: 0.2),
                                  child: Text(
                                    user.username.isNotEmpty ? user.username[0].toUpperCase() : 'U',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isThisUserPremium ? Colors.amber.shade900 : AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              user.username,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isThisUserPremium) ...[
                                            const SizedBox(width: 8),
                                            const PremiumBadge(),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        user.email,
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      Text(
                                        'Registered: ${user.registeredAt} • Status: ${isThisUserPremium ? "Active Premium (1-Month)" : "Free Tier"}',
                                        style: TextStyle(fontSize: 11, color: isThisUserPremium ? AppColors.primaryGreenDark : Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isThisUserPremium ? Colors.red.shade100 : AppColors.primaryGreen,
                                    foregroundColor: isThisUserPremium ? Colors.red.shade900 : Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () async {
                                    final newStatus = !isThisUserPremium;
                                    await userRegistry.setPremiumStatus(user.email, newStatus);
                                    if (newStatus) {
                                      await ref.read(premiumStorageProvider.notifier).grantOneMonthPremium();
                                    } else {
                                      await ref.read(premiumStorageProvider.notifier).revokePremium();
                                    }
                                    setState(() {});
                                  },
                                  child: Text(
                                    isThisUserPremium ? 'Revoke' : 'Grant Premium',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                const SizedBox(height: 28),

                // SECTION 2: Customer Support Messages (Reply & Delete with Priority Sorting)
                const Text(
                  '2. Customer Support Messages (Priority Queue) 📩',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Note: Support is for all users. Tickets from Premium members are prioritized at the top.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: tickets.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('No customer support messages received yet.')),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tickets.length,
                          separatorBuilder: (context, index) => const Divider(height: 24),
                          itemBuilder: (context, index) {
                            final ticket = tickets[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (ticket.isPremium) ...[
                                      const PremiumBadge(),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: Text(
                                        '[${ticket.category}] ${ticket.subject}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                      ticket.submittedAt,
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'From: ${ticket.username} (${ticket.userEmail})',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreenDark),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Text(
                                    ticket.message,
                                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                                  ),
                                ),
                                if (ticket.reply != null) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Admin Reply (${ticket.repliedAt}):',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primaryGreenDark),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          ticket.reply!,
                                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.primaryGreen,
                                        side: const BorderSide(color: AppColors.primaryGreen),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      ),
                                      icon: const Icon(Icons.reply_rounded, size: 16),
                                      label: Text(ticket.reply == null ? 'Reply' : 'Edit Reply'),
                                      onPressed: () => _showReplyDialog(ticket),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                                      tooltip: 'Delete Ticket',
                                      onPressed: () async {
                                        await supportStorage.deleteMessage(ticket.id);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                ),
                const SizedBox(height: 28),

                // SECTION 3: Google Ads Configuration
                const Text(
                  '3. Google Ads (AdMob) Setup 📢',
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
                        subtitle: const Text('Monetize app sessions with Google AdMob banners for Free members.'),
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

                // SECTION 4: Banking & Revenue Payout Setup
                const Text(
                  '4. Banking & Revenue Payout Setup 🏦',
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
