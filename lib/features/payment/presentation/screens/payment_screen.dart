import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/storage/premium_storage.dart';
import '../../../../core/storage/user_registry_storage.dart';
import '../../../admin/presentation/screens/admin_panel_screen.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/widgets/shared/in_app_notification_banner.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Simulate bank transaction processing
    await Future.delayed(const Duration(seconds: 2));

    // 1. Mark local user as Premium for 1 Month (30 days)
    await ref.read(premiumStorageProvider).grantOneMonthPremium();

    // 2. Sync to Admin User Registry
    final authState = ref.read(authControllerProvider);
    final email = authState.user?.email ?? 'learner@linguai.com';
    await ref.read(userRegistryStorageProvider).setPremiumStatus(email, true);

    if (mounted) {
      setState(() => _isProcessing = false);

      InAppNotificationBanner.show(
        context: context,
        title: 'Payment Successful! 🎉',
        message: 'Congratulations! Your 1-Month Premium Pass is active. Enjoy AI Tutor & Unlimited Hearts!',
        type: NotificationType.success,
      );

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) context.go('/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminSettingsProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.paymentScreenTitle),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Premium Plan Summary Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, size: 44, color: Colors.black),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LinguAI 1-Month Premium Pass 👑',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Includes AI Tutor, Ad-Free experience, Unlimited Hearts (∞) & Priority Support.',
                                style: TextStyle(fontSize: 13, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Admin Payout Banking Info Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_balance_rounded, color: AppColors.primaryGreen),
                            const SizedBox(width: 8),
                            Text(
                              loc.adminBankingDetails,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryGreenDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('${loc.bankNameLabel} ${adminState.bankName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('${loc.accountHolderLabel} ${adminState.accountHolderName}', style: const TextStyle(fontSize: 13)),
                        Text('${loc.ibanLabel} ${adminState.ibanNumber}', style: const TextStyle(fontSize: 13)),
                        Text('${loc.swiftLabel} ${adminState.swiftCode}', style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Credit / Debit Card Form
                  const Text(
                    'Card Payment Details 💳',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _nameController,
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter cardholder name' : null,
                    decoration: InputDecoration(
                      labelText: loc.cardHolderName,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.replaceAll(' ', '').length < 12) {
                        return 'Enter a valid 16-digit card number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: loc.cardNumber,
                      hintText: '4532 •••• •••• 8912',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.credit_card_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryController,
                          keyboardType: TextInputType.datetime,
                          validator: (val) => (val == null || !val.contains('/')) ? 'MM/YY' : null,
                          decoration: InputDecoration(
                            labelText: loc.expiryDate,
                            hintText: '12/28',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.calendar_today_rounded),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          validator: (val) => (val == null || val.length < 3) ? '3 digits' : null,
                          decoration: InputDecoration(
                            labelText: loc.cvvCode,
                            hintText: '•••',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Pay Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                      ),
                      icon: _isProcessing
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.verified_rounded),
                      label: Text(
                        _isProcessing ? 'Processing Payment...' : loc.payAndUnlock,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onPressed: _isProcessing ? null : _processPayment,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
