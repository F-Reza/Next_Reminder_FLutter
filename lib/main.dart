import 'package:flutter/material.dart';
import 'package:next_reminder/view/reminder_screen.dart';
import 'package:provider/provider.dart';
import 'providers/reminder_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReminderProvider(),
      child: MaterialApp(
        title: 'Reminder App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ReminderScreen(),
      ),
    );
  }
}
