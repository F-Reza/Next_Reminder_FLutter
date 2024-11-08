// notification_service.dart
import 'package:flutter/material.dart';

class NotificationService extends ChangeNotifier {
  // Your notification logic here

  void scheduleNotification() {
    // Logic to schedule notifications
    notifyListeners();  // Notify listeners when something changes
  }
}
