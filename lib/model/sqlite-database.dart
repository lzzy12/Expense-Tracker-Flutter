import 'package:personal_expenses_flutter/model/Data.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:core';
import 'package:path/path.dart';

class SingletonDatabase {
  Future<Database> _db;
  static final SingletonDatabase _instance = SingletonDatabase._internal();
  static const version = 1;
  static const tableName = 'expenses_v$version';

  factory SingletonDatabase() {
    return _instance;
  }

  SingletonDatabase._internal();

  Future<void> open() async {
    final path = await getDatabasesPath();
    String mPath = join(path, 'Expenses.db');
    if (_db == null) {
      _db = openDatabase(mPath, onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $tableName(id TEXT PRIMARY KEY, expenseName TEXT, amount DECIMAL, date DATETIME)');
      }, version: version);
    }
  }

  Future<void> insert(Expense e) async {
    open();
    final database = await _db;
    await database.insert(
      tableName,
      e.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAll(List<Expense> e) async {
    for (var i in e) {
      await insert(i);
    }
  }

  Future<List<Expense>> getAll() async {
    await open();
    final database = await _db;
    var maps = await database.query(tableName);
    return List.generate(maps.length, (i) {
      return Expense(
          maps[i]['id'],
          maps[i]['expenseName'],
          maps[i]['amount'].toDouble(),
          (DateTime.fromMillisecondsSinceEpoch(maps[i]['date'])));
    });
  }

  Future<void> delete(Expense e) async {
    open();
    final database = await _db;
    await database
        .delete(tableName, where: 'id = ?', whereArgs: <String>[e.id]);
  }

  Future<void> update(Expense e) async {
    open();
    final database = await _db;
    await database
        .update(tableName, e.toMap(), where: 'id = ?', whereArgs: [e.id]);
  }
}
