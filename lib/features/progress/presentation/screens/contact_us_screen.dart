import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_constants.dart';
import '../../../../core/widgets/shared/in_app_notification_banner.dart';
import '../../../../core/widgets/shared/primary_button.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedCategory = 'General Feedback';
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

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      InAppNotificationBanner.show(
        context: context,
        title: 'Feedback Sent! 📩',
        message: 'Thank you! Our team has received your message and will review it promptly.',
        type: NotificationType.success,
      );

      _subjectController.clear();
      _messageController.clear();

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contact Us & Feedback'),
        elevation: 0,
      ),
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
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.support_agent_rounded, color: AppColors.primaryGreen, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'We value your feedback! Send us your complaints, feature ideas, or support requests.',
                        style: TextStyle(fontSize: 13, color: AppColors.primaryGreenDark, fontWeight: FontWeight.w600),
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
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      );
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
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a subject' : null,
                decoration: InputDecoration(
                  hintText: 'Brief summary of your topic',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter your message details' : null,
                decoration: InputDecoration(
                  hintText: 'Describe your issue, complaint, or feedback in detail...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppConstants.space32),
              PrimaryButton(
                text: 'Submit Feedback',
                onPressed: _submitFeedback,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
