import 'package:sqflite/sqflite.dart';

import 'app_database.dart';
import '../models/product.dart';

class ProductDatabaseHelper {
  static const String tableName = 'products';

  // Get the count of products added by each shop_id
  Future<int> countProductsByShopId(int shopId) async {
    final db = await AppDatabase().database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM $tableName WHERE shop_id = ?',
      [shopId],
    );

    return Sqflite.firstIntValue(result) ?? 0; // Return 0 if no products found
  }

  // Fetch all products by shop_id
  Future<List<Product>> getProductsByShopId(int shopId) async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'shop_id = ?',
      whereArgs: [shopId],
    );

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> insertProduct(Product product) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, product.toMap(),
        where: 'pro_id = ?', whereArgs: [product.proId]);
  }

  Future<int> deleteProduct(int proId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'pro_id = ?', whereArgs: [proId]);
  }
}
