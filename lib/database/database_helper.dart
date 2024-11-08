
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_model.dart';
import '../models/reminder _model.dart';


class DBHelper {
  static const _dbName = 'reminder_db';
  static const _dbVersion = 1;
  static const reminderTable = 'reminders';
  static const categoryTable = 'categories';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  _initDb() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $reminderTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      category TEXT,
      dateTime TEXT
    )''');
    await db.execute('''
    CREATE TABLE $categoryTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )''');
  }

  Future<int> insertReminder(Reminder reminder) async {
    final db = await database;
    return await db.insert(reminderTable, reminder.toMap());
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(reminderTable);
    return List.generate(maps.length, (i) {
      return Reminder.fromMap(maps[i]);
    });
  }

  Future<List<Reminder>> getRemindersByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      reminderTable,
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) {
      return Reminder.fromMap(maps[i]);
    });
  }

  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(reminderTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await database;
    return await db.update(
      reminderTable,
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert(categoryTable, category.toMap());
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(categoryTable);
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(categoryTable, where: 'id = ?', whereArgs: [id]);
  }
}
