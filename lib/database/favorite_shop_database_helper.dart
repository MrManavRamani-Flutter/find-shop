import 'package:find_shop/database/app_database.dart';
import 'package:find_shop/models/favorite_shop.dart';

class FavoriteShopDatabaseHelper {
  static const String tableName = 'favorite_shops';

  // Insert a favorite shop into the database
  Future<int> insertFavoriteShop(FavoriteShop favoriteShop) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, favoriteShop.toMap());
  }

  // Get all favorite shops for a specific user
  Future<List<FavoriteShop>> getFavoriteShops(int userId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT favorite_shops.* FROM favorite_shops
    INNER JOIN shops ON favorite_shops.shop_id = shops.shop_id
    INNER JOIN users ON shops.user_id = users.user_id
    WHERE favorite_shops.user_id = ? AND users.status != 2
  ''', [userId]);

    return List.generate(maps.length, (i) {
      return FavoriteShop.fromMap(maps[i]);
    });
  }


  // Delete a favorite shop by shopId and userId
  Future<int> deleteFavoriteShop(int shopId, int userId) async {
    final db = await AppDatabase().database;
    return await db.delete(
      tableName,
      where: 'shop_id = ? AND user_id = ?', // Ensure correct shop and user
      whereArgs: [shopId, userId],
    );
  }

  // Check if a shop is a favorite for a specific user
  Future<bool> isShopFavoriteForUser(int shopId, int userId) async {
    final db = await AppDatabase().database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'shop_id = ? AND user_id = ?',
      whereArgs: [shopId, userId],
    );
    return result.isNotEmpty; // Returns true if the shop is marked as favorite
  }
}
