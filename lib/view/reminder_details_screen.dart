import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/category_model.dart';
import '../models/reminder _model.dart';

class ReminderDetailScreen extends StatefulWidget {
  final Reminder reminder;
  final VoidCallback onDelete;

  ReminderDetailScreen({required this.reminder, required this.onDelete});

  @override
  _ReminderDetailScreenState createState() => _ReminderDetailScreenState();
}

class _ReminderDetailScreenState extends State<ReminderDetailScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  List<Category> categories = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers and selected values from the passed Reminder object
    titleController.text = widget.reminder.title;
    descriptionController.text = widget.reminder.description;
    selectedCategory = widget.reminder.category;
    dateController.text = DateFormat('dd/MM/yyyy - hh:mm a').format(widget.reminder.dateTime);
    _fetchCategories();
  }

  // Fetch categories from the database
  Future<void> _fetchCategories() async {
    categories = await _dbHelper.getCategories(); // Assuming getCategories returns a list of categories
    setState(() {});
  }

  // Date picker to allow users to select a new date
  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.reminder.dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.reminder.dateTime),
      );
      if (pickedTime != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        dateController.text = DateFormat('dd/MM/yyyy - hh:mm a').format(newDateTime);
      }
    }
  }

  // Update the reminder in the database
  Future<void> _updateReminder() async {
    final updatedReminder = Reminder(
      id: widget.reminder.id,
      title: titleController.text,
      description: descriptionController.text,
      category: selectedCategory!,
      dateTime: DateFormat('dd/MM/yyyy - hh:mm a').parse(dateController.text),
    );
    await _dbHelper.updateReminder(updatedReminder);
    Navigator.pop(context, true); // Return true to indicate an update was made
  }

  // Delete the reminder from the database
  void _deleteReminder() async {
    await _dbHelper.deleteReminder(widget.reminder.id!);
    widget.onDelete(); // Call the onDelete callback to update the list in the parent screen
    Navigator.pop(context, true); // Return true to indicate a deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Reminder'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteReminder,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title field
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            // Description field
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            // Category dropdown with pre-selected category
            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: Text('Select Category'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              items: categories.map((Category category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(category.name),
                );
              }).toList(),
            ),
            // Date picker field with pre-selected date
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date and Time'),
              readOnly: true,
              onTap: _selectDateTime,
            ),
            SizedBox(height: 20),
            // Save button
            ElevatedButton(
              onPressed: _updateReminder,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
