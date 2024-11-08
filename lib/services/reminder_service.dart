import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/reminder _model.dart';


class ReminderService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'reminder_app.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE reminders(id INTEGER PRIMARY KEY, title TEXT, description TEXT, category TEXT, date TEXT, time TEXT)');
      },
      version: 1,
    );
    return _database!;
  }

  Future<void> insertReminder(Reminder reminder) async {
    final db = await database;
    await db.insert('reminders', reminder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) {
      return Reminder.fromMap(maps[i]);
    });
  }

  Future<void> deleteReminder(int id) async {
    final db = await database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateReminder(Reminder reminder) async {
    final db = await database;
    await db.update('reminders', reminder.toMap(),
        where: 'id = ?', whereArgs: [reminder.id]);
  }
}
