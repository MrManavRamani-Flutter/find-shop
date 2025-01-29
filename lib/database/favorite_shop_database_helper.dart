import 'app_database.dart';
import '../models/favorite_shop.dart';

class FavoriteShopDatabaseHelper {
  static const String tableName = 'favorite_shops';

  Future<int> insertFavoriteShop(FavoriteShop favoriteShop) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, favoriteShop.toMap());
  }

  Future<List<FavoriteShop>> getFavoriteShops() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return FavoriteShop.fromMap(maps[i]);
    });
  }

  Future<int> deleteFavoriteShop(int favId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'fav_id = ?', whereArgs: [favId]);
  }
}
