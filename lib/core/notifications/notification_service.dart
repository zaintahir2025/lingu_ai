import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationService(dio);
});

class NotificationService {
  final Dio _dio;

  NotificationService(this._dio);

  Future<void> init() async {
    if (kIsWeb) {
      try {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          _showLocalNotification(
            title: message.notification?.title ?? 'New Message',
            body: message.notification?.body ?? '',
            payload: message.data['route'],
          );
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          if (message.data.containsKey('route')) {
            _handleNotificationClick(message.data['route'] as String);
          }
        });
      } catch (e) {
        debugPrint('FCM Web Init error: $e');
      }
      return;
    }

    // Initialize Local Notifications for Mobile and Desktop
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'Open notification');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    try {
      await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (response) {
          // Handle deep link from local notification
          final payload = response.payload;
          if (payload != null) {
            _handleNotificationClick(payload);
          }
        },
      );
    } catch (e) {
      debugPrint('Local notifications init error: $e');
    }

    // Setup Firebase Messaging handlers if mobile/web
    if (Platform.isAndroid || Platform.isIOS) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(
          title: message.notification?.title ?? 'New Message',
          body: message.notification?.body ?? '',
          payload: message.data['route'],
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // Handle tap from background state
        if (message.data.containsKey('route')) {
          _handleNotificationClick(message.data['route'] as String);
        }
      });
    }
  }

  void _handleNotificationClick(String route) {
    // Ideally use GoRouter to navigate. We'll emit an event or rely on a GlobalKey.
    // This will be handled in the main app router.
  }

  Future<void> _showLocalNotification({required String title, required String body, String? payload}) async {
    if (kIsWeb) return;
    
    const androidDetails = AndroidNotificationDetails(
      'linguai_channel',
      'LinguAI Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(android: androidDetails, iOS: darwinDetails, macOS: darwinDetails);
    
    await flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  Future<bool> requestPermission() async {
    bool granted = false;

    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission();
      granted = settings.authorizationStatus == AuthorizationStatus.authorized;
    } else if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      // Request local notifications permission
      if (Platform.isMacOS) {
        final result = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        granted = result ?? false;
      } else if (Platform.isWindows || Platform.isLinux) {
        // Usually granted by default or managed by OS settings directly.
        granted = true;
      }
    }

    if (granted) {
      await _registerDeviceToken();
    }

    return granted;
  }

  Future<void> _registerDeviceToken() async {
    String? token;
    String platformStr = 'unknown';

    try {
      if (kIsWeb) {
        token = await FirebaseMessaging.instance.getToken(
          vapidKey: 'BMmock-vapid-key-for-web-push',
        );
        platformStr = 'web';
      } else if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        token = await FirebaseMessaging.instance.getToken();
        platformStr = Platform.operatingSystem;
      } else {
        // Desktop: No FCM token.
        platformStr = Platform.operatingSystem;
        token = 'desktop-local-only';
      }
    } catch (e) {
      debugPrint('FCM Token error: $e');
      token = 'mock-token-fallback';
    }

    if (token != null) {
      try {
        await _dio.post(
          '/user/device/register',
          data: {
            'token': token,
            'platform': platformStr,
          },
        );
      } catch (e) {
        debugPrint('Mock API Device register error: $e');
      }
    }
  }

  Future<void> scheduleLocalReminder(String title, String body, {Duration delay = const Duration(hours: 24), String? route}) async {
    // For a real app, use timezone package and zonedSchedule.
    // Using a delayed Future for simple demonstration of local reminder while app is open
    Future.delayed(delay, () {
      _showLocalNotification(title: title, body: body, payload: route);
    });
  }
}
