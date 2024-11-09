import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/reminder _model.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> scheduleReminder(Reminder reminder) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    // Convert DateTime to TZDateTime
    final tzDateTime = tz.TZDateTime.from(reminder.dateTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
        reminder.id ?? 0,                        // ID
        'Reminder: ${reminder.title}',            // Title
        reminder.description,                     // Body
        tzDateTime,                               // TZDateTime
        platformDetails,                          // NotificationDetails
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Time-based repeat option
        androidScheduleMode: AndroidScheduleMode.exact     // Exact scheduling
    );
  }
}
