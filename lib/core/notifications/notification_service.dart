import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  NotificationService();

  Future<void> init() async {
    if (kIsWeb) return;

    try {
      tz_data.initializeTimeZones();
      final currentTimezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimezone.identifier));

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      final InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsIOS,
          );

      await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {},
      );
    } catch (e) {
      debugPrint('Local notifications init skipped: $e');
    }
  }

  Future<bool> requestPermission() async {
    bool granted = false;
    if (kIsWeb) {
      granted = true;
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      try {
        final result = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        granted = result ?? false;
      } catch (_) {
        granted = true;
      }
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();

        final result = await androidImplementation
            ?.requestNotificationsPermission();
        granted = result ?? false;
      } catch (_) {
        granted = true;
      }
    } else {
      granted = true;
    }
    return granted;
  }

  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    if (kIsWeb ||
        !(defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      return;
    }

    final granted = await requestPermission();
    if (!granted) throw StateError('Notification permission was not granted.');

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'linguai_daily_learning',
        'Daily learning reminders',
        channelDescription: 'Reminders to continue your daily language lesson.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 1001,
      title: 'Ready for today’s lesson?',
      body: 'Keep your streak alive with a quick LinguAI practice session.',
      scheduledDate: scheduled,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<String?> getDeviceToken() async {
    // This app currently uses local notifications and has no push provider.
    return null;
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
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
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    try {
      await flutterLocalNotificationsPlugin.show(
        id: DateTime.now().millisecondsSinceEpoch.remainder(1 << 31),
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
    } catch (error) {
      debugPrint('Local notification could not be shown: $error');
    }
  }
}
