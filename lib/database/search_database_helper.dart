import 'app_database.dart';
import '../models/search.dart';

class SearchDatabaseHelper {
  static const String tableName = 'search';

  Future<int> insertSearch(Search search) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, search.toMap());
  }

  Future<List<Search>> getSearches() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Search.fromMap(maps[i]);
    });
  }

  Future<int> deleteSearch(int searchId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'search_id = ?', whereArgs: [searchId]);
  }
}
