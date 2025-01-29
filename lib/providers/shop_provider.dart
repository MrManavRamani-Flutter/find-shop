import 'package:flutter/material.dart';
import '../models/shop.dart';
import '../database/shop_database_helper.dart';

class ShopProvider with ChangeNotifier {
  List<Shop> _shops = [];

  List<Shop> get shops => _shops;

  Future<void> fetchShops() async {
    final shopsList = await ShopDatabaseHelper().getShops();
    _shops = shopsList;
    notifyListeners();
  }

  Future<void> addShop(Shop shop) async {
    await ShopDatabaseHelper().insertShop(shop);
    await fetchShops();
  }

  Future<void> updateShop(Shop shop) async {
    await ShopDatabaseHelper().updateShop(shop);
    await fetchShops();
  }

  Future<void> deleteShop(int shopId) async {
    await ShopDatabaseHelper().deleteShop(shopId);
    await fetchShops();
  }
}
