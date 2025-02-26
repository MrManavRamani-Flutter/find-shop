import 'app_database.dart';
import '../models/area.dart';

class AreaDatabaseHelper {
  static const String tableName = 'areas';

  // Insert a new area into the database
  Future<int> insertArea(Area area) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, area.toMap());
  }

  // Fetch the first 5 areas from the database
  Future<List<Area>> getTop5Areas() async {
    final db = await AppDatabase().database;

    // Query to fetch only the first 5 areas
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      limit: 5,
    );

    // Convert the fetched maps into a list of Area objects
    return List.generate(maps.length, (i) {
      return Area.fromMap(maps[i]);
    });
  }

  // Fetch all areas from the database
  Future<List<Area>> getAreas() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Area.fromMap(maps[i]);
    });
  }

  // Fetch an area by its ID
  Future<Area?> getAreaById(int areaId) async {
    final db = await AppDatabase().database;
    try {
      final result = await db.query(
        tableName,
        where: 'area_id = ?',
        whereArgs: [areaId],
      );

      // If an area is found, return the area object
      if (result.isNotEmpty) {
        return Area.fromMap(result.first);
      } else {
        return null; // Return null if area is not found
      }
    } catch (e) {
      throw Exception('Error fetching area by ID: $e');
    }
  }

  // Update an existing area in the database
  Future<int> updateArea(Area area) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, area.toMap(),
        where: 'area_id = ?', whereArgs: [area.areaId]);
  }

  // Delete an area from the database by its ID
  Future<int> deleteArea(int areaId) async {
    final db = await AppDatabase().database;
    return await db
        .delete(tableName, where: 'area_id = ?', whereArgs: [areaId]);
  }
}
