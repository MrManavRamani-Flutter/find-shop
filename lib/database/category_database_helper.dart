import 'app_database.dart';
import '../models/category.dart';

class CategoryDatabaseHelper {
  static const String tableName = 'categories';

  // Insert a new category into the database
  Future<int> insertCategory(Category category) async {
    final db = await AppDatabase().database;

    // Ensure catId is set to null for auto-increment behavior
    category.catId = null;

    return await db.insert(tableName, category.toMap());
  }

  // Retrieve all categories from the database
  Future<List<Category>> getTop5Categories() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      limit: 5,
    );
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  // Retrieve all categories from the database
  Future<List<Category>> getCategories() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  // Update an existing category in the database
  Future<int> updateCategory(Category category) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, category.toMap(),
        where: 'cat_id = ?', whereArgs: [category.catId]);
  }

  // Delete a category from the database by its ID
  Future<int> deleteCategory(int catId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'cat_id = ?', whereArgs: [catId]);
  }
}
