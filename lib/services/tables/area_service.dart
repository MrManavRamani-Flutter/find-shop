import 'package:sqflite/sqflite.dart';

class AreaService {
  final Database db;

  AreaService(this.db);

  // Create areas table
  Future<void> createAreasTable() async {
    await db.execute('''
      CREATE TABLE areas (
        area_id INTEGER PRIMARY KEY AUTOINCREMENT,
        area_name TEXT NOT NULL UNIQUE
      )
    ''');
  }

  // Insert a new area
  Future<int> insertArea(Map<String, dynamic> area) async {
    return await db.insert('areas', area);
  }

  // Fetch all areas
  Future<List<Map<String, dynamic>>> getAreas() async {
    return await db.query('areas');
  }
}
