import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, 'countries.db');

    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      ByteData data = await rootBundle.load('assets/countries.db');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }

    return await openDatabase(dbPath);
  }

  // Search for countries by name

  Future<List<Map<String, dynamic>>> searchCountries(String query) async {
    final db = await database;
    return await db.query(
      'country', // Replace with your table name
      where:
          'country_name LIKE ? COLLATE NOCASE', // Replace 'name' with your column name
      whereArgs: ['%$query%'], // Using % to match partial search terms
    );
  }

  Future<List<Map<String, dynamic>>> getRecords(String tableName) async {
    final db = await database;
    try {
      return await db.query(tableName);
    } catch (e) {
      print('Error fetching records from $tableName: $e');
      return [];
    }
  }
}
