import 'app_database.dart';
import '../models/area.dart';

class AreaDatabaseHelper {
  static const String tableName = 'areas';

  Future<int> insertArea(Area area) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, area.toMap());
  }

  Future<List<Area>> getAreas() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Area.fromMap(maps[i]);
    });
  }

  // Fetch a area by their ID
  Future<Area?> getAreaById(int areaId) async {
    final db = await AppDatabase().database;
    try {
      final result = await db.query(
        tableName,
        where: 'area_id = ?',
        whereArgs: [areaId],
      );

      // If a area is found, return the area object
      if (result.isNotEmpty) {
        return Area.fromMap(result.first);
      } else {
        return null; // Return null if area is not found
      }
    } catch (e) {
      throw Exception('Error fetching area by ID: $e');
    }
  }

  Future<int> updateArea(Area area) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, area.toMap(), where: 'area_id = ?', whereArgs: [area.areaId]);
  }

  Future<int> deleteArea(int areaId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'area_id = ?', whereArgs: [areaId]);
  }
}
