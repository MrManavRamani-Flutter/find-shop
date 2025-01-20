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

  // Update user
  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.userId],
    );
  }

  // Update shop
  Future<int> updateShop(Shop shop) async {
    final db = await _dbHelper.database;
    return await db.update(
      'shops',
      shop.toMap(),
      where: 'id = ?',
      whereArgs: [shop.shopId],
    );
  }

  // Update area
  Future<int> updateArea(Area area) async {
    final db = await _dbHelper.database;
    return await db.update(
      'areas',
      area.toMap(),
      where: 'id = ?',
      whereArgs: [area.areaId],
    );
  }

  // Update category
  Future<int> updateCategory(Category category) async {
    final db = await _dbHelper.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.catId],
    );
  }

  // Update product
  Future<int> updateProduct(Product product) async {
    final db = await _dbHelper.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.productId],
    );
  }

  // Update favorite shop
  Future<int> updateFavoriteShop(FavoriteShop favoriteShop) async {
    final db = await _dbHelper.database;
    return await db.update(
      'favorite_shop',
      favoriteShop.toMap(),
      where: 'id = ?',
      whereArgs: [favoriteShop.favId],
    );
  }

  // Update search
  Future<int> updateSearch(Search search) async {
    final db = await _dbHelper.database;
    return await db.update(
      'search',
      search.toMap(),
      where: 'id = ?',
      whereArgs: [search.searchId],
    );
  }

  // Update shop review
  Future<int> updateShopReview(ShopReview shopReview) async {
    final db = await _dbHelper.database;
    return await db.update(
      'shop_reviews',
      shopReview.toMap(),
      where: 'id = ?',
      whereArgs: [shopReview.reviewId],
    );
  }
}
