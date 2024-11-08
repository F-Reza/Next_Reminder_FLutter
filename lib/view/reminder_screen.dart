import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';

class ReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reminders")),
      body: Consumer<ReminderProvider>(
        builder: (context, reminderProvider, child) {
          return ListView.builder(
            itemCount: reminderProvider.reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminderProvider.reminders[index];
              return ListTile(
                title: Text(reminder.title),
                subtitle: Text("${reminder.date.toString()} ${reminder.time.format(context)}"),
                onTap: () {
                  // Navigate to the Edit screen or perform another action
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddReminderScreen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
