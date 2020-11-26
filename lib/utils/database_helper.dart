import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoit/models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  final String tableName = "taskTable";
  final String columnId = "id";
  final String columnTask = "taskName";
  final String columnDate = "taskDate";
  final String isDone = "isDone";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "taskdb.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $tableName("
      "$columnId INTEGER PRIMARY KEY,"
      " $columnTask TEXT, "
      "$columnDate TEXT,"
      "$isDone INTEGER)",
    );
  }

  // Insert
  Future<int> saveTask(Task task) async {
    var dbClient = await db;
    int res = await dbClient.insert('$tableName', task.toMap());
    return res;
  }

  // Get Task
  Future<List> getAllTask() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName ORDER BY $columnId DESC");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future<Task> getTask(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE $columnId = $id");
    if (result.length == 0) return null;
    return Task.fromMap(result.first);
  }

  Future<int> deleteTask(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<void> update(int value, Task task) async {
    var dbClient = await db;

    await dbClient.rawUpdate('''
      UPDATE $tableName SET $isDone = ? 
      WHERE $columnId = ?
    ''', [value, task.id]);
  }

  Future<int> updateTask(Task task) async {
    var dbClient = await db;
    return await dbClient.update(tableName, task.toMap(),
        where: "$columnId = ?", whereArgs: [task.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
