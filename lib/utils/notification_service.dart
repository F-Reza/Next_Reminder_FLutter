import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/reminder _model.dart';

//It's Work
class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notificationsPlugin.initialize(settings);

    // Initialize the timezone data
    tzData.initializeTimeZones();
  }

  // Request permission for exact alarms (for Android 12+)
  static Future<void> requestExactAlarmPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      // Proceed with scheduling the alarm
    } else {
      // Handle permission denial
    }
  }

  // Schedule the reminder notification
  static Future<void> scheduleReminder(Reminder reminder) async {
    await requestExactAlarmPermission();

    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    // Use the device's local timezone
    final location = tz.local;  // This correctly gets the device's local time zone
    final tzDateTime = tz.TZDateTime.from(reminder.dateTime, location);

    // Schedule the notification with inexact alarm for Android 12+
    await _notificationsPlugin.zonedSchedule(
      reminder.id ?? 0,
      'Reminder: ${reminder.title}',
      reminder.description,
      tzDateTime,
      platformDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexact,  // Use inexact scheduling
    );
  }


}
