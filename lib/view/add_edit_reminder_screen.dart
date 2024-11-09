import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../models/reminder _model.dart';
import 'package:intl/intl.dart';

import '../utils/notification_service.dart';

class AddEditReminderScreen extends StatefulWidget {
  final Reminder? reminder;
  AddEditReminderScreen({this.reminder});

  @override
  _AddEditReminderScreenState createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      _titleController.text = widget.reminder!.title;
      _descriptionController.text = widget.reminder!.description;
      _categoryController.text = widget.reminder!.category;
      _selectedDateTime = widget.reminder!.dateTime;
    }
  }

  Future<void> _saveReminder() async {
    final reminder = Reminder(
      id: widget.reminder?.id,
      title: _titleController.text,
      description: _descriptionController.text,
      category: _categoryController.text,
      dateTime: _selectedDateTime,
    );

    if (widget.reminder == null) {
      Provider.of<DBHelper>(context, listen: false).insertReminder(reminder);
      await NotificationHelper.scheduleReminder(reminder);
    } else {
      Provider.of<DBHelper>(context, listen: false).updateReminder(reminder);
      await NotificationHelper.scheduleReminder(reminder);
    }

    Navigator.pop(context);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateTime) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'Add Reminder' : 'Edit Reminder'),
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
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            ListTile(
              title: Text('Date & Time: ${DateFormat.yMd().add_jm().format(_selectedDateTime)}'),
              onTap: () => _selectDateTime(context),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveReminder,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
