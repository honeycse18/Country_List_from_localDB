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
    // Get the path to the device's documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, 'Wali2WaliDB.db');

    // Check if the database exists in the documents directory
    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      // If the database doesn't exist, copy it from assets to the documents directory
      ByteData data = await rootBundle.load('assets/Wali2WaliDB.db');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write the data to the local file
      await File(dbPath).writeAsBytes(bytes);
      print('Database copied from assets');
    } else {
      print('Database already exists in the documents directory');
    }

    // Open the database
    return await openDatabase(dbPath);
  }

  // Example method to retrieve countries from the database
  Future<List<Map<String, dynamic>>> getCountries() async {
    final db = await database;
    return await db.query('list_of_countries');
  }
}
