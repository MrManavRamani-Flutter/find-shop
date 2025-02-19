import 'package:find_shop/database/user_database_helper.dart';
import 'package:flutter/material.dart';
import '../models/shop.dart';
import '../database/shop_database_helper.dart';

class ShopProvider with ChangeNotifier {
  List<Shop> _shops = [];
  Shop? shop;

  List<Shop> get shops => _shops;

  // Fetch all shops from the database
  Future<void> fetchShops() async {
    final shopsList = await ShopDatabaseHelper().getShops();
    _shops = shopsList;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Fetch shops filtered by users with roleId == 2 and status == 1
  Future<void> fetchShopsByUserStatus() async {
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

    notifyListeners(); // Notify listeners to update the UI
  }

  // Get a specific shop by userId
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

  // Fetch shop by userId from the database
  Future<void> fetchShopByUserId(int userId) async {
    final fetchedShop = await ShopDatabaseHelper().getShopByUserID(userId);
    if (fetchedShop != null) {
      shop = fetchedShop;
      notifyListeners(); // Notify listeners when the shop data changes
    }
  }

  // Add a new shop and refresh the list of shops
  Future<int> addShop(Shop shop) async {
    final shopId = await ShopDatabaseHelper().insertShop(shop);
    await fetchShops(); // Refresh the list after adding
    return shopId;
  }

  // Update an existing shop and refresh the list of shops
  Future<void> updateShop(Shop shop) async {
    await ShopDatabaseHelper().updateShop(shop);
    await fetchShops(); // Refresh the list after updating
  }

  // Update map address for a shop
  Future<void> updateShopMapAddress(int shopId, String newMapAddress) async {
    final currentShop = await ShopDatabaseHelper().getShopByUserID(shopId);

    if (currentShop != null) {
      final updatedShop = currentShop.copyWith(mapAddress: newMapAddress);

      await ShopDatabaseHelper().updateShop(updatedShop);

      if (shop?.shopId == shopId) {
        shop = updatedShop;
      }
      await fetchShops();
      notifyListeners(); // Notify the UI to rebuild.
    }
  }

  // Delete a shop and refresh the list of shops
  Future<void> deleteShop(int shopId) async {
    await ShopDatabaseHelper().deleteShop(shopId);
    await fetchShops(); // Refresh the list after deletion
  }
}
