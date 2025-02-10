import 'app_database.dart';
import '../models/shop_category.dart';

class ShopCategoryDatabaseHelper {
  static const String tableName = 'shop_categories';

  // Insert a new shop category into the database
  Future<int> insertShopCategory(ShopCategory shopCategory) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, shopCategory.toMap());
  }

  // Fetch all categories for a specific shop
  Future<List<ShopCategory>> getShopCategoriesForShop(int shopId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'shop_id = ?',
      whereArgs: [shopId],
    );

    return List.generate(maps.length, (i) {
      return ShopCategory.fromMap(maps[i]);
    });
  }

  // Fetch all shop categories from the database
  Future<List<ShopCategory>> getShopCategories() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return ShopCategory.fromMap(maps[i]);
    });
  }

  // Update an existing shop category by its ID
  Future<int> updateShopCategory(ShopCategory shopCategory) async {
    final db = await AppDatabase().database;
    return await db.update(
      tableName,
      shopCategory.toMap(),
      where: 'shop_cat_id = ?',
      whereArgs: [shopCategory.shopCatId],
    );
  }

  // Delete a shop category by its ID
  Future<int> deleteShopCategory(int shopCatId) async {
    final db = await AppDatabase().database;
    return await db.delete(
      tableName,
      where: 'shop_cat_id = ?',
      whereArgs: [shopCatId],
    );
  }
}
