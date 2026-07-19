import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/widgets/shared/app_card.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: AppColors.primaryGreen, size: 64),
              ),
              const SizedBox(height: 24),
              Text(
                'Unlock AI Tutor',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Get unlimited personalized language practice with our advanced AI tutor. It identifies your weak points and helps you master the language faster.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 32),
              AppCard(
                child: Column(
                  children: [
                    _buildFeatureItem('Unlimited Chat Practice', Icons.chat),
                    const SizedBox(height: 16),
                    _buildFeatureItem('Personalized Feedback', Icons.feedback),
                    const SizedBox(height: 16),
                    _buildFeatureItem('Smart Error Correction', Icons.fact_check),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                text: 'Start Free Trial',
                onPressed: () {
                  // In a real app, integrate RevenueCat / IAP here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payments not implemented in this demo.')),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Maybe Later', style: TextStyle(color: AppColors.textSecondary)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGreen),
        const SizedBox(width: 16),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
