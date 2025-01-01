import '../models/area_model/area.dart';
import '../models/category_model/category.dart';
import '../models/favorite_model/favorite_shop.dart';
import '../models/product_model/product.dart';
import '../models/review_model/shop_review.dart';
import '../models/search_model/search.dart';
import '../models/shop_model/shop.dart';
import '../models/user_model/user.dart';
import 'database_helper.dart';

class DataFetcher {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Fetch all users
  Future<List<User>> fetchAllUsers() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (index) {
      return User.fromMap(maps[index]);
    });
  }

  // Fetch all shops
  Future<List<Shop>> fetchAllShops() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('shops');
    return List.generate(maps.length, (index) {
      return Shop.fromMap(maps[index]);
    });
  }

  // Fetch all areas
  Future<List<Area>> fetchAllAreas() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('areas');
    return List.generate(maps.length, (index) {
      return Area.fromMap(maps[index]);
    });
  }

  // Fetch all categories
  Future<List<Category>> fetchAllCategories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (index) {
      return Category.fromMap(maps[index]);
    });
  }

  // Fetch all products
  Future<List<Product>> fetchAllProducts() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (index) {
      return Product.fromMap(maps[index]);
    });
  }

  // Fetch all favorite shops
  Future<List<FavoriteShop>> fetchAllFavoriteShops() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('favorite_shop');
    return List.generate(maps.length, (index) {
      return FavoriteShop.fromMap(maps[index]);
    });
  }

  // Fetch all searches
  Future<List<Search>> fetchAllSearches() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('search');
    return List.generate(maps.length, (index) {
      return Search.fromMap(maps[index]);
    });
  }

  // Fetch all shop reviews
  Future<List<ShopReview>> fetchAllShopReviews() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('shop_reviews');
    return List.generate(maps.length, (index) {
      return ShopReview.fromMap(maps[index]);
    });
  }
}
