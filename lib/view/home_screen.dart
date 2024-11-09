import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_reminder/view/reminder_details_screen.dart';
import '../database/database_helper.dart';
import '../models/reminder _model.dart';
import '../models/category_model.dart';
import '../utils/notification_service.dart';
import 'category_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Reminder> reminders = [];
  List<Category> categories = [];
  final DBHelper _dbHelper = DBHelper();
  String? selectedCategory;

  // Fetch reminders and categories from the database
  void _fetchData() async {
    final remindersData = await _dbHelper.getAllReminders();
    final categoriesData = await _dbHelper.getCategories();
    setState(() {
      reminders = remindersData;
      categories = categoriesData;
      selectedCategory = null;  // Reset the selected category
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
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(hintText: 'Enter title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: 'Enter description'),
                    ),
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
                                _fetchData();
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
                            setState(() {
                              dataTime = formattedDate;
                            });
                            dateController.text = selectedDateTime.toString();
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
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        selectedCategory != null) {

                      DateTime parsedDateTime;

                      if (dateController.text.isEmpty) {
                        String formattedDate = DateFormat('dd/MM/yyyy - hh:mm a').format(DateTime.now());
                        DateTime pDateTime = DateFormat('dd/MM/yyyy - hh:mm a').parse(formattedDate);
                        parsedDateTime = pDateTime;
                        dateController.text = DateTime.now().toString();
                      } else {
                        parsedDateTime = DateFormat('dd/MM/yyyy - hh:mm a')
                            .parse(dateController.text);
                      }

                      Reminder newReminder = Reminder(
                        title: titleController.text,
                        description: descriptionController.text,
                        category: selectedCategory!,
                        dateTime: parsedDateTime,
                      );
                      await _dbHelper.insertReminder(newReminder);



                      _fetchData();
                      Navigator.pop(context);
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
    NotificationHelper.initNotifications();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1690ca),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Next Reminder', style: TextStyle(color: Colors.white,),),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: selectedCategory,
              hint: Text("Filter by Category..."),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              isExpanded: true,
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text("All Categories"),
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
          Expanded(
            child: reminders.isEmpty
                ? Center(child: Text('No reminders added yet.'))
                : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                // Filter reminders based on selected category
                if (selectedCategory != null &&
                    reminders[index].category != selectedCategory) {
                  return SizedBox.shrink();
                }

                DateTime parsedDate = DateTime.parse((reminders[index].dateTime.toString()));
                String formattedDate = DateFormat('dd/MM/yyyy - hh:mm a').format(parsedDate);
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReminderDetailScreen(
                          reminder: reminders[index],
                          onDelete: () {
                            setState(() {
                              reminders.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                    if (result == true) {
                      _fetchData();
                    }
                  },
                  child: Card(
                    elevation: 5,
                    color: const Color(0xFF1690ca),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        formattedDate,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        reminders[index].title,
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                      trailing: Icon(Icons.notifications, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: Icon(Icons.add),
      ),
    );
  }
}

