import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/connectivity_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../mascot/piko_mascot.dart';
import 'package:lingu_ai/l10n/app_localizations.dart';

class OfflineGate extends ConsumerWidget {
  final Widget child;
  final String? title;
  final String? message;

  const OfflineGate({super.key, required this.child, this.title, this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider).value ?? true;

    if (!isOnline) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.space32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PikoMascot(pose: PikoPose.sad, size: 150),
              const SizedBox(height: AppConstants.space32),
              Text(
                title ?? AppLocalizations.of(context)!.offlineTitleDefault,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: AppConstants.space16),
              Text(
                message ?? AppLocalizations.of(context)!.offlineMessageDefault,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      );
    }

    return child;
  }
}
