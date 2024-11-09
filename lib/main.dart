import 'package:flutter/material.dart';
import 'package:next_reminder/view/home_screen.dart';
import 'package:provider/provider.dart';

import 'database/database_helper.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DBHelper>(
      create: (context) => DBHelper(),
      child: MaterialApp(
        title: 'Reminder App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}