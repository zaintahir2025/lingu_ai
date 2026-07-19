import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/widgets/shared/app_card.dart';
import '../../../../core/widgets/shared/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';
import '../widgets/turnstile_widget.dart';
import '../../../../core/widgets/shared/in_app_notification_banner.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  String? _turnstileToken;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final text = _passwordController.text;
    setState(() {
      _hasMinLength = text.length >= 8;
      _hasNumber = RegExp(r'[0-9]').hasMatch(text);
      _hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }



  void _register() {
    if (!_hasMinLength || !_hasNumber || !_hasSpecialChar) return;
    
    if (_turnstileToken == null) {
      InAppNotificationBanner.show(
        context: context,
        title: 'Error',
        message: 'Please complete the CAPTCHA.',
        type: NotificationType.error,
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      InAppNotificationBanner.show(
        context: context,
        title: 'Error',
        message: 'Passwords do not match.',
        type: NotificationType.error,
      );
      return;
    }

    ref.read(authControllerProvider.notifier).register(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  Widget _buildChecklistRow(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isValid ? AppColors.primaryGreen : AppColors.textSecondary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.authenticating;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.registerError != next.registerError && next.registerError != null) {
        if (!context.mounted || ModalRoute.of(context)?.isCurrent != true) return;
        InAppNotificationBanner.show(
          context: context,
          title: 'Message',
          message: next.registerError!,
          type: next.status == AuthStatus.authenticated ? NotificationType.success : NotificationType.error,
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.createAccountTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.emailLabel,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.passwordLabel,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocus),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _register(),
                  ),
                  const SizedBox(height: 12),
                  _buildChecklistRow(AppLocalizations.of(context)!.passwordMinLength, _hasMinLength),
                  const SizedBox(height: 4),
                  _buildChecklistRow(AppLocalizations.of(context)!.passwordContainsNumber, _hasNumber),
                  const SizedBox(height: 4),
                  _buildChecklistRow(AppLocalizations.of(context)!.passwordContainsSpecialChar, _hasSpecialChar),
                  const SizedBox(height: 16),
                  TurnstileWidget(
                    siteKey: '1x00000000000000000000AA', // Test site key
                    onTokenReceived: (token) {
                      setState(() {
                        _turnstileToken = token;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: isLoading ? AppLocalizations.of(context)!.registeringLabel : AppLocalizations.of(context)!.registerTitle,
                    onPressed: isLoading ? null : _register,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(AppLocalizations.of(context)!.alreadyHaveAccountLabel),
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
