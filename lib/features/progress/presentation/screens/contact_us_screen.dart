import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/in_app_notification_banner.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/storage/premium_storage.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/widgets/shared/premium_badge.dart';
import '../../data/support_repository.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  const ContactUsScreen({super.key});

  @override
  ConsumerState<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends ConsumerState<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedCategory = 'General Feedback';
  bool _isSubmitting = false;
  final List<String> _categories = const [
    'General Feedback',
    'Bug Report 🐛',
    'Feature Request 💡',
    'Account & Enrolment',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    final authState = ref.read(authControllerProvider);
    if (authState.user == null) {
      InAppNotificationBanner.show(
        context: context,
        title: 'Sign in required',
        message: 'Please sign in before submitting a support request.',
        type: NotificationType.error,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final isPremium = ref.read(premiumStorageProvider);
      await ref
          .read(supportRepositoryProvider)
          .createTicket(
            category: _selectedCategory,
            subject: _subjectController.text.trim(),
            message: _messageController.text.trim(),
          );

      if (mounted) {
        InAppNotificationBanner.show(
          context: context,
          title: isPremium ? 'Priority Ticket Sent! ⚡' : 'Feedback Sent! 📩',
          message: isPremium
              ? 'Your message has been assigned High Priority. Our premium support team will reply shortly.'
              : 'Thank you! Our team has received your message and will review it promptly.',
          type: NotificationType.success,
        );

        _subjectController.clear();
        _messageController.clear();

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (error) {
      if (mounted) {
        InAppNotificationBanner.show(
          context: context,
          title: 'Could not send ticket',
          message: error.toString().replaceFirst('Exception: ', ''),
          type: NotificationType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(premiumStorageProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Contact Us & Support'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.space24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isPremium
                      ? Colors.amber.shade50
                      : AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isPremium
                        ? Colors.amber
                        : AppColors.primaryGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPremium
                          ? Icons.offline_bolt_rounded
                          : Icons.support_agent_rounded,
                      color: isPremium
                          ? Colors.amber.shade900
                          : AppColors.primaryGreen,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                isPremium
                                    ? 'Priority Support Channel ⚡'
                                    : 'Customer Support',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isPremium
                                      ? Colors.amber.shade900
                                      : AppColors.primaryGreenDark,
                                ),
                              ),
                              if (isPremium) ...[
                                const SizedBox(width: 8),
                                const PremiumBadge(),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isPremium
                                ? 'As a Premium Member, your support tickets are routed directly to our priority desk.'
                                : 'We value your feedback! Send us your complaints, feature ideas, or support requests.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.space24),
              Text(
                'Category',
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
                    value: _selectedCategory,
                    isExpanded: true,
                    items: _categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.space24),
              Text(
                'Subject',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                validator: (val) => (val == null || val.trim().length < 3)
                    ? 'Enter at least 3 characters'
                    : null,
                decoration: InputDecoration(
                  hintText: 'Brief summary of your topic',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: AppConstants.space24),
              Text(
                'Your Message / Complaint',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                validator: (val) => (val == null || val.trim().length < 10)
                    ? 'Enter at least 10 characters'
                    : null,
                decoration: InputDecoration(
                  hintText:
                      'Describe your issue, complaint, or feedback in detail...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppConstants.space32),
              PrimaryButton(
                text: isPremium
                    ? 'Submit Priority Ticket ⚡'
                    : 'Submit Feedback',
                onPressed: _isSubmitting ? null : _submitFeedback,
                isLoading: _isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
