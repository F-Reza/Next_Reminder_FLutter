import 'package:flutter/material.dart';
import '../models/reminder _model.dart';


class AddEditReminderScreen extends StatefulWidget {
  final Reminder reminder;  // Assuming you're passing the reminder object

  AddEditReminderScreen({required this.reminder});

  @override
  _AddEditReminderScreenState createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String selectedCategory = '';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.reminder.title;
    _descriptionController.text = widget.reminder.description;
    selectedCategory = widget.reminder.category;
    selectedDate = widget.reminder.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            // Add dropdown or other UI for category and date
            ElevatedButton(
              onPressed: () {
                // Save the changes
                // You can update the reminder in your database here
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
