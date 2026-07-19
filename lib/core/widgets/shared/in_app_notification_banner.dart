import 'package:flutter/material.dart';

enum NotificationType { success, error, info }

final GlobalKey<InAppNotificationBannerState> inAppBannerKey = GlobalKey<InAppNotificationBannerState>();

class InAppNotificationBanner extends StatefulWidget {
  final Widget child;

  const InAppNotificationBanner({super.key, required this.child});

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
  }) {
    inAppBannerKey.currentState?.showBanner(title, message, type);
  }

  @override
  State<InAppNotificationBanner> createState() => InAppNotificationBannerState();
}

class InAppNotificationBannerState extends State<InAppNotificationBanner> {
  String? _notificationTitle;
  String? _notificationBody;
  NotificationType _notificationType = NotificationType.info;

  @override
  void initState() {
    super.initState();
  }

  void showBanner(String title, String body, NotificationType type) {
    setState(() {
      _notificationTitle = title;
      _notificationBody = body;
      _notificationType = type;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _notificationTitle = null;
          _notificationBody = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_notificationTitle != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      _notificationType == NotificationType.error
                          ? Icons.error_outline
                          : _notificationType == NotificationType.success
                              ? Icons.check_circle_outline
                              : Icons.notifications_active,
                      color: _notificationType == NotificationType.error
                          ? Colors.redAccent
                          : _notificationType == NotificationType.success
                              ? Colors.green
                              : Colors.blueAccent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _notificationTitle!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (_notificationBody != null)
                            Text(
                              _notificationBody!,
                              style: const TextStyle(color: Colors.black54),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () {
                        setState(() {
                          _notificationTitle = null;
                          _notificationBody = null;
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
