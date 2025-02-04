import 'app_database.dart';
import '../models/shop_category.dart';

class ShopCategoryDatabaseHelper {
  static const String tableName = 'shop_categories';

  Future<int> insertShopCategory(ShopCategory shopCategory) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, shopCategory.toMap());
  }

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

  Future<List<ShopCategory>> getShopCategories() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return ShopCategory.fromMap(maps[i]);
    });
  }

  Future<int> updateShopCategory(ShopCategory shopCategory) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, shopCategory.toMap(),
        where: 'shop_cat_id = ?', whereArgs: [shopCategory.shopCatId]);
  }

  Future<int> deleteShopCategory(int shopCatId) async {
    final db = await AppDatabase().database;
    return await db
        .delete(tableName, where: 'shop_cat_id = ?', whereArgs: [shopCatId]);
  }
}
