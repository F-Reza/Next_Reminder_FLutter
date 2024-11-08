import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder _model.dart';
import '../providers/reminder_provider.dart';

class AddEditReminderScreen extends StatefulWidget {
  final Reminder? reminder;
  AddEditReminderScreen({this.reminder});

  @override
  _AddEditReminderScreenState createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reminder?.title ?? '');
    _descriptionController = TextEditingController(text: widget.reminder?.description ?? '');
    _categoryController = TextEditingController(text: widget.reminder?.category ?? '');
    _selectedDate = widget.reminder?.date ?? DateTime.now();
    _selectedTime = widget.reminder?.time ?? TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.reminder == null ? "Add Reminder" : "Edit Reminder")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: "Description")),
            TextField(controller: _categoryController, decoration: InputDecoration(labelText: "Category")),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Text("Pick Date"),
            ),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (picked != null && picked != _selectedTime) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
              child: Text("Pick Time"),
            ),
            ElevatedButton(
              onPressed: () {
                final newReminder = Reminder(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  category: _categoryController.text,
                  date: _selectedDate,
                  time: _selectedTime,
                );
                if (widget.reminder == null) {
                  Provider.of<ReminderProvider>(context, listen: false).addReminder(newReminder);
                } else {
                  newReminder.id = widget.reminder?.id;
                  Provider.of<ReminderProvider>(context, listen: false).updateReminder(newReminder);
                }
                Navigator.pop(context);
              },
              child: Text(widget.reminder == null ? "Add Reminder" : "Update Reminder"),
            ),
          ],
        ),
      ),
    );
  }
}
