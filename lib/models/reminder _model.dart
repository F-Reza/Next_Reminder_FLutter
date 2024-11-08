import 'package:flutter/material.dart';

class Reminder {
  int? id;
  String title;
  String description;
  String category;
  DateTime date;
  TimeOfDay time;

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
  });

  // Remove time formatting from the toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'time': time.toString(),  // Save time as string or number, without formatting
    };
  }

  Reminder.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        category = map['category'],
        date = DateTime.parse(map['date']),
        time = TimeOfDay.fromDateTime(DateTime.parse(map['time']));
}
