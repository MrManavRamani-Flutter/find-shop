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

  Future<int> updateArea(Area area) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, area.toMap(), where: 'area_id = ?', whereArgs: [area.areaId]);
  }

  Future<int> deleteArea(int areaId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'area_id = ?', whereArgs: [areaId]);
  }
}
