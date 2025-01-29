import 'package:flutter/material.dart';
import '../models/favorite_shop.dart';
import '../database/favorite_shop_database_helper.dart';

class FavoriteShopProvider with ChangeNotifier {
  List<FavoriteShop> _favoriteShops = [];

  List<FavoriteShop> get favoriteShops => _favoriteShops;

  Future<void> fetchFavoriteShops() async {
    final favoriteShopsList = await FavoriteShopDatabaseHelper().getFavoriteShops();
    _favoriteShops = favoriteShopsList;
    notifyListeners();
  }

  Future<void> addFavoriteShop(FavoriteShop favoriteShop) async {
    await FavoriteShopDatabaseHelper().insertFavoriteShop(favoriteShop);
    await fetchFavoriteShops();
  }

  Future<void> deleteFavoriteShop(int favId) async {
    await FavoriteShopDatabaseHelper().deleteFavoriteShop(favId);
    await fetchFavoriteShops();
  }
}
