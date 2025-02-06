import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:find_shop/database/favorite_shop_database_helper.dart';
import 'package:find_shop/models/favorite_shop.dart';

class FavoriteShopProvider with ChangeNotifier {
  final FavoriteShopDatabaseHelper _dbHelper = FavoriteShopDatabaseHelper();
  final SharedPreferencesHelper _sharedPrefsHelper = SharedPreferencesHelper();

  List<FavoriteShop> _favoriteShops = [];

  List<FavoriteShop> get favoriteShops => _favoriteShops;

  // Fetch favorite shops for a specific user
  Future<void> fetchFavoriteShopsByUserId() async {
    final userId = await _sharedPrefsHelper.getUserId();
    if (userId != null) {
      _favoriteShops = await _dbHelper.getFavoriteShops(userId);
      notifyListeners();
    }
  }

  // Check if a shop is in the favorites list for the current user
  Future<bool> isFavorite(int shopId) async {
    final userId = await _sharedPrefsHelper.getUserId();
    if (userId != null) {
      return await _dbHelper.isShopFavoriteForUser(shopId, userId);
    }
    return false;
  }

  // Toggle a shop's favorite status (add or remove)
  Future<void> toggleFavoriteShop(int shopId) async {
    final userId = await _sharedPrefsHelper.getUserId();
    if (userId != null) {
      bool isShopFavorite = await isFavorite(shopId);

      if (isShopFavorite) {
        await _deleteFavoriteShop(shopId, userId);
      } else {
        await _addFavoriteShop(shopId, userId);
      }
    }
  }

  // Add a shop to the favorites list
  Future<void> _addFavoriteShop(int shopId, int userId) async {
    String currentTime = DateTime.now().toIso8601String();
    // Create a new FavoriteShop instance with the addedAt field
    FavoriteShop favoriteShop = FavoriteShop(
      shopId: shopId,
      userId: userId,
      addedAt: currentTime, // Set addedAt to the current time
    );

    await _dbHelper.insertFavoriteShop(favoriteShop);
    _favoriteShops.add(favoriteShop);
    notifyListeners();
  }

  // Remove a shop from the favorites list
  Future<void> _deleteFavoriteShop(int shopId, int userId) async {
    await _dbHelper.deleteFavoriteShop(shopId, userId);
    _favoriteShops.removeWhere(
      (favShop) => favShop.shopId == shopId && favShop.userId == userId,
    );
    notifyListeners();
  }
}
