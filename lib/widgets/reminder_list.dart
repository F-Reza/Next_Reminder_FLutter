import 'package:flutter/material.dart';

class ReminderService extends ChangeNotifier {
  // Your state variables and methods
  List<Reminder> reminders = [];

  void addReminder(Reminder reminder) {
    reminders.add(reminder);
    notifyListeners();  // Notify listeners when state changes
  }

  void removeReminder(int id) {
    reminders.removeWhere((reminder) => reminder.id == id);
    notifyListeners();  // Notify listeners when state changes
  }
}

class Reminder {
  int id;
  String title;
  String description;
  String category;
  DateTime date;
  TimeOfDay time;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
  });
}
