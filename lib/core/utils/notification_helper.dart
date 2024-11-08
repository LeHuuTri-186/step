import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../features/home/domain/entities/todo.dart';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static int generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static Future<void> init() async {

    const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    // Initialize notifications
    await _notification.initialize(initSettings);

    // Explicitly request permissions on iOS
    _notification
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> cancelNotification(int notificationId) async {
    await _notification.cancel(notificationId);
    debugPrint("Notification with ID $notificationId has been canceled.");
  }

  static Future<void> pushNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint("Preparing to show notification...");

    const androidDetails = AndroidNotificationDetails(
      'important_channel',
      'My Channel',
      channelDescription: 'This channel is for important notifications.',
      importance: Importance.max,
      priority: Priority.max,
    );

    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notification.show(
      100,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    debugPrint("Notification should be shown.");
  }

  static Future<void> scheduleNotification({
    required Todo todo,
    String? payload,
  }) async {

    const androidDetails = AndroidNotificationDetails(
      'important_channel',
      'My Channel',
      channelDescription: 'This channel is for important notifications.',
      importance: Importance.max,
      priority: Priority.max,
    );

    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (todo.notificationId == null) {
      return;
    }

    await _notification.zonedSchedule(
      todo.notificationId!,
      todo.title,
      todo.description,
      tz.TZDateTime.from(todo.deadline!, tz.local),
      notificationDetails,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
