import 'app_database.dart';
import '../models/product.dart';

class ProductDatabaseHelper {
  static const String tableName = 'products';

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
    return await db.update(tableName, product.toMap(), where: 'pro_id = ?', whereArgs: [product.proId]);
  }

  Future<int> deleteProduct(int proId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'pro_id = ?', whereArgs: [proId]);
  }
}
