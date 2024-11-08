import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder _model.dart';
import 'add_edit_reminder_screen.dart';
import 'category_screen.dart';
import '../services/reminder_service.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminders')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditReminderScreen()));
            },
            child: Text('Add Reminder'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen()));
            },
            child: Text('Manage Categories'),
          ),
          Expanded(
            child: FutureBuilder<List<Reminder>>(
              future: Provider.of<ReminderService>(context).getReminders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No reminders found.'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final reminder = snapshot.data![index];
                    return ListTile(
                      title: Text(reminder.title),
                      subtitle: Text(reminder.description),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Delete reminder
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
