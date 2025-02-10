import 'app_database.dart';
import '../models/shop.dart';

class ShopDatabaseHelper {
  static const String tableName = 'shops';

  // Insert a new shop into the database
  Future<int> insertShop(Shop shop) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, shop.toMap());
  }

  // Fetch all shops from the database
  Future<List<Shop>> getShops() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Shop.fromMap(maps[i]);
    });
  }

  // Get a shop by the associated user ID
  Future<Shop?> getShopByUserID(int userId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> result =
    await db.query(tableName, where: 'user_id = ?', whereArgs: [userId]);

    if (result.isNotEmpty) {
      return Shop.fromMap(result.first); // Convert first result to Shop object
    } else {
      return null; // Return null if no shop found
    }
  }

  // Get all shops that belong to a specific category
  Future<List<Shop>> getShopsByCategory(int categoryId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT shops.* FROM shops
      INNER JOIN shop_categories ON shops.shop_id = shop_categories.shop_id
      WHERE shop_categories.cat_id = ?
    ''', [categoryId]);

    return List.generate(results.length, (i) {
      return Shop.fromMap(results[i]);
    });
  }

  // Update an existing shop by its ID
  Future<int> updateShop(Shop shop) async {
    final db = await AppDatabase().database;
    return await db.update(
      tableName,
      shop.toMap(),
      where: 'shop_id = ?',
      whereArgs: [shop.shopId],
    );
  }

  // Delete a shop by its ID
  Future<int> deleteShop(int shopId) async {
    final db = await AppDatabase().database;
    return await db.delete(
      tableName,
      where: 'shop_id = ?',
      whereArgs: [shopId],
    );
  }
}
