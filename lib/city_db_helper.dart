import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class CityHelper {
  static final CityHelper _instance = CityHelper._internal();
  factory CityHelper() => _instance;

  static Database? _cityDatabase;

  CityHelper._internal();

  Future<Database> get cityDatabase async {
    if (_cityDatabase != null) return _cityDatabase!;
    _cityDatabase = await _initCityDatabase();
    return _cityDatabase!;
  }

  Future<Database> _initCityDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, 'city.db');

    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      ByteData data = await rootBundle.load('assets/city.db');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }

    return await openDatabase(dbPath);
  }

  // Fetch all cities
  Future<List<Map<String, dynamic>>> getAllCities() async {
    final db = await cityDatabase;
    return await db.query('city');
  }

  // Search cities by name
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    final db = await cityDatabase;
    return await db.query(
      'city',
      where: 'city_name LIKE ? COLLATE NOCASE',
      whereArgs: ['%$query%'],
    );
  }
}
