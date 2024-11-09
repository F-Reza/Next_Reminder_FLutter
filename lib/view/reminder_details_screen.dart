import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../models/reminder _model.dart';


class ReminderDetailScreen extends StatelessWidget {
  final Reminder reminder;
  ReminderDetailScreen({required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reminder.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${reminder.description}', style: TextStyle(fontSize: 18)),
            Text('Category: ${reminder.category}', style: TextStyle(fontSize: 18)),
            Text('Date & Time: ${reminder.dateTime}', style: TextStyle(fontSize: 18)),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Provider.of<DBHelper>(context, listen: false)
                    .deleteReminder(reminder.id!);
                Navigator.pop(context);
              },
              child: Text('Delete Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
