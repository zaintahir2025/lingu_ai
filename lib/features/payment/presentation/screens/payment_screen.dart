import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/storage/premium_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shared/app_card.dart';
import '../../../../core/widgets/shared/in_app_notification_banner.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/payment_repository.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _busy = false;
  VerifiedSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    Future.microtask(_refresh);
  }

  String _message(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  void _notify(String title, String message, NotificationType type) {
    if (!mounted) return;
    InAppNotificationBanner.show(
      context: context,
      title: title,
      message: message,
      type: type,
    );
  }

  Future<void> _refresh() async {
    if (ref.read(authControllerProvider).status != AuthStatus.authenticated) {
      return;
    }
    setState(() => _busy = true);
    try {
      final result = await ref
          .read(paymentRepositoryProvider)
          .refreshSubscription();
      if (mounted) setState(() => _subscription = result);
    } catch (error) {
      _notify(
        'Subscription check failed',
        _message(error),
        NotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openCheckout() async {
    if (ref.read(authControllerProvider).status != AuthStatus.authenticated) {
      _notify(
        'Sign in required',
        'Sign in before purchasing Premium.',
        NotificationType.error,
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final url = await ref
          .read(paymentRepositoryProvider)
          .createCheckoutSession();
      final opened = await launchUrl(
        url,
        mode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
        webOnlyWindowName: '_self',
      );
      if (!opened) {
        throw Exception('Could not open the secure Stripe checkout.');
      }
    } catch (error) {
      _notify('Checkout unavailable', _message(error), NotificationType.error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _manageSubscription() async {
    setState(() => _busy = true);
    try {
      final url = await ref
          .read(paymentRepositoryProvider)
          .createPortalSession();
      final opened = await launchUrl(
        url,
        mode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
        webOnlyWindowName: '_self',
      );
      if (!opened) throw Exception('Could not open the Stripe billing portal.');
    } catch (error) {
      _notify(
        'Billing portal unavailable',
        _message(error),
        NotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticated =
        ref.watch(authControllerProvider).status == AuthStatus.authenticated;
    final premium = ref.watch(premiumStorageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LinguAI Premium'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.workspace_premium_rounded,
                    size: 72,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    premium ? 'Premium is active' : 'Unlock LinguAI Premium',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unlimited AI tutoring, no ads, unlimited hearts, and priority support.',
                    textAlign: TextAlign.center,
                  ),
                  if (_subscription?.expiresAt != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Current period ends ${_subscription!.expiresAt!.toLocal().toString().split(' ').first}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                  const SizedBox(height: 28),
                  if (!authenticated)
                    ElevatedButton(
                      onPressed: _busy ? null : () => context.go('/auth/login'),
                      child: const Text('SIGN IN TO CONTINUE'),
                    )
                  else if (premium)
                    ElevatedButton.icon(
                      onPressed: _busy ? null : _manageSubscription,
                      icon: const Icon(Icons.settings),
                      label: const Text('MANAGE SUBSCRIPTION'),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _busy ? null : _openCheckout,
                      icon: const Icon(Icons.lock),
                      label: Text(
                        _busy
                            ? 'OPENING SECURE CHECKOUT…'
                            : 'CONTINUE TO SECURE CHECKOUT',
                      ),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _busy || !authenticated ? null : _refresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('REFRESH PURCHASE STATUS'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Payments are processed by Stripe. LinguAI never receives or stores your card number, expiry date, or security code.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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
