import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the notifications and timezone data
  Future<void> initialize() async {
    tzdata.initializeTimeZones(); // Initialize the timezone data
    final initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Convert DateTime to TZDateTime
  tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    final location = tz.getLocation('America/New_York'); // Choose your timezone location
    return tz.TZDateTime.from(dateTime, location);
  }

  // Show the notification
  Future<void> showNotification(int id, String title, String body, DateTime dateTime) async {
    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    // Convert the DateTime to TZDateTime
    tz.TZDateTime scheduledTime = _convertToTZDateTime(dateTime);

    // Schedule the notification using the correct parameters
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,  // Corrected
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}
