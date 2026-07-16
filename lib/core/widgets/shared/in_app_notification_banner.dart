import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../theme/app_colors.dart';

import 'package:lingu_ai/l10n/app_localizations.dart';

class InAppNotificationBanner extends ConsumerStatefulWidget {
  final Widget child;

  const InAppNotificationBanner({super.key, required this.child});

  @override
  ConsumerState<InAppNotificationBanner> createState() => _InAppNotificationBannerState();
}

class _InAppNotificationBannerState extends ConsumerState<InAppNotificationBanner> {
  RemoteMessage? _currentMessage;

  @override
  void initState() {
    super.initState();
    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (mounted) {
        setState(() {
          _currentMessage = message;
        });

        // Hide banner after 4 seconds
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted && _currentMessage == message) {
            setState(() {
              _currentMessage = null;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_currentMessage != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentMessage!.notification?.title ?? AppLocalizations.of(context)!.notificationFallbackTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (_currentMessage!.notification?.body != null)
                            Text(
                              _currentMessage!.notification!.body!,
                              style: const TextStyle(color: AppColors.textSecondary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      tooltip: 'Dismiss notification',
                      onPressed: () {
                        setState(() {
                          _currentMessage = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
