import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReminderService extends ChangeNotifier {
  List<String> reminders = [];

  void addReminder(String reminder) {
    reminders.add(reminder);
    notifyListeners();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ReminderService>(create: (_) => ReminderService()),
      ],
      child: MaterialApp(
        title: 'Reminder App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Access ReminderService and add a reminder
            context.read<ReminderService>().addReminder('New Reminder');
          },
          child: Text('Add Reminder'),
        ),
      ),
    );
  }
}
