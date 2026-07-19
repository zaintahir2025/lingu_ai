import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../user/presentation/controllers/user_controller.dart';
import '../../../../core/widgets/shared/app_card.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _usernameController = TextEditingController();
  DateTime? _selectedDob;
  String _selectedAvatar = 'bird';

  final List<String> avatars = ['bird', 'cat', 'ninja', 'robot'];

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_usernameController.text.trim().isEmpty) return;
    if (_selectedDob == null) return;

    await ref.read(userControllerProvider.notifier).updateProfile(
      username: _usernameController.text.trim(),
      avatarId: _selectedAvatar,
      dob: _selectedDob,
    );
    if (!mounted) return;
    context.go('/lang-choice');
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Create Your Profile',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a fun avatar and pick a username!',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: avatars.map((avatar) {
                  final isSelected = _selectedAvatar == avatar;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatar = avatar),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                          width: 4,
                        ),
                        color: AppColors.surface,
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.background,
                        child: Text(
                          avatar == 'bird' ? '🐦' : avatar == 'cat' ? '🐱' : avatar == 'ninja' ? '🥷' : '🤖',
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              AppCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _pickDob,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Age (Date of Birth)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          _selectedDob == null
                              ? 'Select Date of Birth'
                              : '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (userState.error != null)
                Text(userState.error!, style: const TextStyle(color: AppColors.softErrorText)),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Continue',
                onPressed: userState.isLoading ? null : _submit,
                isLoading: userState.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
