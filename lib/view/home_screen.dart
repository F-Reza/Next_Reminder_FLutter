import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/reminder _model.dart';
import '../models/category_model.dart';
import 'category_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Reminder> reminders = [];
  List<Category> categories = []; // List to hold categories
  final DBHelper _dbHelper = DBHelper();
  String? selectedCategory; // Variable to hold selected category

  // Fetch reminders and categories from the database
  void _fetchData() async {
    final remindersData = await _dbHelper.getAllReminders();
    final categoriesData = await _dbHelper.getCategories();
    setState(() {
      reminders = remindersData;
      categories = categoriesData;
      selectedCategory = null; // Ensure selectedCategory is null initially
    });
  }

  // Method to add a new reminder
  void _addReminder() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        String? dataTime;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Reminder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title TextField
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(hintText: 'Enter title'),
                    ),
                    // Description TextField
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: 'Enter description'),
                    ),
                    // Check if categories list is empty
                    categories.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "No categories found. Please add a category.",
                            style: TextStyle(color: Colors.red),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryScreen(),
                                ),
                              ).then((_) {
                                _fetchData(); // Refresh categories after adding a new category
                              });
                            },
                            child: Text("Add Category"),
                          ),
                        ],
                      ),
                    )
                        : Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        hint: Text("Select Category..."),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        isExpanded: true,
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text("Select Category..."),
                          ),
                          ...categories.map((Category category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Text(category.name),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    Text(dateController.text),
                    TextButton(
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (selectedDate != null) {
                          TimeOfDay? selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (selectedTime != null) {
                            final DateTime selectedDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            String formattedDate = DateFormat('dd/MM/yyyy - hh:mm a')
                                .format(selectedDateTime);
                            dateController.text = formattedDate;
                            setState(() {
                              dataTime = formattedDate;
                            });
                          }
                        }
                      },
                      child: Text('Select date and time'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog without saving
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        selectedCategory != null) {
                      DateTime parsedDateTime;

                      // If date is not selected, use the current date and time
                      if (dateController.text.isEmpty) {
                        String formattedDate = DateFormat('dd/MM/yyyy - hh:mm a').format(DateTime.now());
                        DateTime pdDateTime = DateFormat('dd/MM/yyyy - hh:mm a').parse(formattedDate);
                        parsedDateTime = pdDateTime;
                      } else {
                        // Parse the formatted date string into DateTime
                        parsedDateTime = DateFormat('dd/MM/yyyy - hh:mm a')
                            .parse(dateController.text);
                      }

                      // Create new reminder and save it
                      Reminder newReminder = Reminder(
                        title: titleController.text,
                        description: descriptionController.text,
                        category: selectedCategory!,
                        dateTime: parsedDateTime, // Use parsed DateTime
                      );
                      await _dbHelper.insertReminder(newReminder);
                      _fetchData(); // Refresh the reminder list
                      Navigator.pop(context); // Close the dialog
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );

      },
    );
  }



  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch reminders and categories when screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryScreen()),
              ).then((_) {
                // After coming back from CategoryScreen, refresh categories
                _fetchData();
              });
            },
          ),
        ],
      ),
      body: reminders.isEmpty
          ? Center(child: Text('No reminders added yet.'))
          : ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(reminders[index].title),
              subtitle: Text(reminders[index].description),
              trailing: Icon(Icons.notifications),
              onTap: () {
                // Navigate to reminder details or edit screen if needed
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: Icon(Icons.add),
      ),
    );
  }
}
