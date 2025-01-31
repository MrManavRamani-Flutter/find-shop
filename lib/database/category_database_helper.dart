import 'app_database.dart';
import '../models/category.dart';

class CategoryDatabaseHelper {
  static const String tableName = 'categories';

  // Future<int> insertCategory(Category category) async {
  //   final db = await AppDatabase().database;
  //   return await db.insert(tableName, category.toMap());
  // }
  Future<int> insertCategory(Category category) async {
    final db = await AppDatabase().database;

    // Make sure catId is set to null for auto-increment behavior
    category.catId = null;

    return await db.insert(tableName, category.toMap());
  }

  Future<List<Category>> getCategories() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> updateCategory(Category category) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, category.toMap(),
        where: 'cat_id = ?', whereArgs: [category.catId]);
  }

  Future<int> deleteCategory(int catId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'cat_id = ?', whereArgs: [catId]);
  }
}
