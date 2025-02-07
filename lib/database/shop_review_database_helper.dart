import 'app_database.dart';
import '../models/shop_review.dart';

class ShopReviewDatabaseHelper {
  static const String tableName = 'shop_reviews';

  /// Check if the current user has already reviewed a specific shop
  Future<bool> hasUserReviewedShop(int userId, int shopId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'user_id = ? AND shop_id = ?',
      whereArgs: [userId, shopId],
    );
    return result.isNotEmpty;
  }

  Future<int> insertShopReview(ShopReview shopReview) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, shopReview.toMap());
  }

  // Modify the method to filter reviews based on shopId
  Future<List<ShopReview>> getShopReviewsByShopId(int shopId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'shop_id = ?',
      whereArgs: [shopId],
    );
    return List.generate(maps.length, (i) {
      return ShopReview.fromMap(maps[i]);
    });
  }

  Future<List<ShopReview>> getShopReviews() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return ShopReview.fromMap(maps[i]);
    });
  }

  Future<int> updateShopReview(ShopReview shopReview) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, shopReview.toMap(),
        where: 'rev_id = ?', whereArgs: [shopReview.revId]);
  }

  Future<int> deleteShopReview(int revId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'rev_id = ?', whereArgs: [revId]);
  }
}
