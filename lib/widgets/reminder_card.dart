import 'package:flutter/material.dart';

import '../models/reminder _model.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final String formattedDate;

  const ReminderCard({
    Key? key,
    required this.reminder,
    required this.formattedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          reminder.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reminder.description),
            const SizedBox(height: 4),
            Text(
              'Due: $formattedDate',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Handle edit reminder functionality here
          },
        ),
      ),
    );
  }
}
