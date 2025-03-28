import 'package:sqflite/sqflite.dart';

import 'app_database.dart';
import '../models/shop_review.dart';

class ShopReviewDatabaseHelper {
  static const String tableName = 'shop_reviews';

  // Get the total number of reviews for a specific shop
  Future<int> getShopReviewCount(int shopId) async {
    final db = await AppDatabase().database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE shop_id = ?',
      [shopId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Check if a user has already reviewed a specific shop
  Future<bool> hasUserReviewedShop(int userId, int shopId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'user_id = ? AND shop_id = ?',
      whereArgs: [userId, shopId],
    );
    return result.isNotEmpty;
  }

  // Insert a new shop review into the database
  Future<int> insertShopReview(ShopReview shopReview) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, shopReview.toMap());
  }

  // Get all reviews written by a specific user
  Future<List<ShopReview>> getShopReviewsByUserId(int userId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return ShopReview.fromMap(maps[i]);
    });
  }

  // Get all reviews for a specific shop
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

  // Get all shop reviews from the database
  Future<List<ShopReview>> getShopReviews() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return ShopReview.fromMap(maps[i]);
    });
  }

  // Update an existing shop review
  Future<int> updateShopReview(ShopReview shopReview) async {
    final db = await AppDatabase().database;
    return await db.update(
      tableName,
      shopReview.toMap(),
      where: 'rev_id = ?',
      whereArgs: [shopReview.revId],
    );
  }

  // Delete a shop review by its ID
  Future<int> deleteShopReview(int revId) async {
    final db = await AppDatabase().database;
    return await db.delete(
      tableName,
      where: 'rev_id = ?',
      whereArgs: [revId],
    );
  }
}
