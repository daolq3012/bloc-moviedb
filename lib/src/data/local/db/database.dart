import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static String get _databaseName => 'app_database.db';

  static int get _versionCode => 1;

  static Database _database;

  Database get database => _database;

  static Future<Database> open() async {
    final path = await _initDatabase(_databaseName);
    _database = await openDatabase(path, version: _versionCode);
    return _database;
  }

  // Please remember close after open
  static Future close() async {
    await _database.close();
  }

  /// delete the db, create the folder and return its path
  static Future<String> _initDatabase(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    // make sure the folder exists
    if (!await Directory(dirname(path)).exists()) {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }
}
