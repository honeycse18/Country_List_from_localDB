import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class CountryDBHelper {
  static final CountryDBHelper _instance = CountryDBHelper._internal();
  factory CountryDBHelper() => _instance;

  static Database? _database;

  CountryDBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, 'Wali2WaliDB.db');

    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      ByteData data = await rootBundle.load('assets/Wali2WaliDB.db');
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
      'list_of_countries', // Replace with your table name
      where:
          'name LIKE ? COLLATE NOCASE', // Replace 'name' with your column name
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
