import 'package:find_shop/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import '../models/shop.dart';
import '../database/shop_database_helper.dart';

class ShopProvider with ChangeNotifier {
  List<Shop> _shops = [];
  Shop? shop;

  List<Shop> get shops => _shops;

  Future<void> fetchShops() async {
    final shopsList = await ShopDatabaseHelper().getShops();
    _shops = shopsList;
    notifyListeners();
  }

  Future<void> fetchShopsByUserStatus() async   {
    final allShops = await ShopDatabaseHelper().getShops();
    final allUsers = await UserDatabaseHelper().getUsers(); // Fetch all users

    // Filter only users with roleId == 2 and status == 1
    final validUserIds = allUsers
        .where((user) => user.roleId == 2 && user.status == 1)
        .map((user) => user.userId)
        .toSet(); // Use a set for quick lookup

    // Filter shops based on valid users
    _shops =
        allShops.where((shop) => validUserIds.contains(shop.userId)).toList();

    notifyListeners();
  }

// Fetch a specific shop by userId
  Shop getShopByUserId(int userId) {
    return _shops.firstWhere(
      (shop) => shop.userId == userId,
      orElse: () => Shop(
        shopId: -1,
        shopName: 'No Shop Found',
        userId: userId,
      ),
    );
  }

  Future<void> fetchShopByUserId(int userId) async {
    final fetchedShop = await ShopDatabaseHelper().getShopByUserID(userId);
    if (fetchedShop != null) {
      shop = fetchedShop;
      notifyListeners(); // Notify listeners when the shop data changes
    }
  }

  Future<int> addShop(Shop shop) async {
    final shopId = await ShopDatabaseHelper().insertShop(shop);
    await fetchShops();
    return shopId;
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
