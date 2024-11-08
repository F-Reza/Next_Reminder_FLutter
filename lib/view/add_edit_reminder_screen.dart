import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder _model.dart';
import '../services/reminder_service.dart';


class AddEditReminderScreen extends StatefulWidget {
  @override
  _AddEditReminderScreenState createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add/Edit Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate)
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Time: ${_selectedTime.format(context)}'),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (pickedTime != null && pickedTime != _selectedTime)
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final reminder = Reminder(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      category: 'General', // Category can be added from a dropdown
                      date: _selectedDate,
                      time: _selectedTime,
                    );
                    Provider.of<ReminderService>(context, listen: false)
                        .insertReminder(reminder);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
