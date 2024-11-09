import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/reminder _model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;


class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notificationsPlugin.initialize(settings);

    // Initialize the timezone data
    tzData.initializeTimeZones();  // This is the correct initialization
  }

  // Schedule the reminder notification
  static Future<void> scheduleReminder(Reminder reminder) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    // Initialize time zone and use local time zone
    final location = tz.getLocation('America/New_York');  // You can change this to 'local' if you want to use the device's local timezone
    final tzDateTime = tz.TZDateTime.from(reminder.dateTime, location);

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      reminder.id ?? 0,  // ID
      'Reminder: ${reminder.title}',  // Title
      reminder.description,  // Body
      tzDateTime,  // DateTime for the notification (in TZDateTime format)
      platformDetails,  // NotificationDetails
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,  // Time-based repeat option
      androidScheduleMode: AndroidScheduleMode.exact,  // Exact scheduling
    );
  }
}
