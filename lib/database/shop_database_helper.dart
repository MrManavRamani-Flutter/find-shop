import 'app_database.dart';
import '../models/shop.dart';

class ShopDatabaseHelper {
  static const String tableName = 'shops';

  Future<int> insertShop(Shop shop) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, shop.toMap());
  }

  Future<List<Shop>> getShops() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Shop.fromMap(maps[i]);
    });
  }

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


  Future<int> updateShop(Shop shop) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, shop.toMap(), where: 'shop_id = ?', whereArgs: [shop.shopId]);
  }

  Future<int> deleteShop(int shopId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'shop_id = ?', whereArgs: [shopId]);
  }
}
