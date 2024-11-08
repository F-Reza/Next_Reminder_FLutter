import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/reminder _model.dart';


class ReminderProvider extends ChangeNotifier {
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  Future<void> loadReminders() async {
    _reminders = await DBHelper.instance.getAllReminders();
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    await DBHelper.instance.insertReminder(reminder);
    await loadReminders();
  }

  Future<void> updateReminder(Reminder reminder) async {
    await DBHelper.instance.updateReminder(reminder);
    await loadReminders();
  }

  Future<void> deleteReminder(int id) async {
    await DBHelper.instance.deleteReminder(id);
    await loadReminders();
  }
}
