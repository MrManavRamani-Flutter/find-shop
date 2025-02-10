import 'package:flutter/material.dart';
import '../models/shop_category.dart';
import '../database/shop_category_database_helper.dart';

class ShopCategoryProvider with ChangeNotifier {
  final List<ShopCategory> _shopCategories = [];
  ShopCategory? _selectedCategory;

  List<ShopCategory> get shopCategories => _shopCategories;
  ShopCategory? get selectedCategory => _selectedCategory;

  // Fetch all shop categories from the database
  Future<void> fetchShopCategories() async {
    try {
      final shopCategoryList = await ShopCategoryDatabaseHelper().getShopCategories();
      _shopCategories.clear();
      _shopCategories.addAll(shopCategoryList);
      notifyListeners(); // Notify listeners to update the UI
    } catch (error) {
      debugPrint('Error fetching shop categories: $error');
    }
  }

  // Fetch categories for a specific shop by shopId
  Future<void> fetchCategoriesForShop(int shopId) async {
    try {
      final shopCategoryList = await ShopCategoryDatabaseHelper().getShopCategoriesForShop(shopId);
      _shopCategories.clear();
      _shopCategories.addAll(shopCategoryList);
      notifyListeners(); // Notify listeners to update the UI
    } catch (error) {
      debugPrint('Error fetching categories for shop $shopId: $error');
    }
  }

  // Add a new shop category and refresh the list
  Future<int> addShopCategory(ShopCategory shopCategory) async {
    try {
      final shopCatId = await ShopCategoryDatabaseHelper().insertShopCategory(shopCategory);
      await fetchShopCategories(); // Refresh the list after adding
      return shopCatId;
    } catch (error) {
      debugPrint('Error adding shop category: $error');
      return -1; // Return -1 if error occurs
    }
  }

  // Update an existing shop category and refresh the list
  Future<void> updateShopCategory(ShopCategory shopCategory) async {
    try {
      await ShopCategoryDatabaseHelper().updateShopCategory(shopCategory);
      await fetchShopCategories(); // Refresh the list after updating
    } catch (error) {
      debugPrint('Error updating shop category: $error');
    }
  }

  // Delete a shop category and refresh the list
  Future<void> deleteShopCategory(int shopCatId) async {
    try {
      await ShopCategoryDatabaseHelper().deleteShopCategory(shopCatId);
      await fetchShopCategories(); // Refresh the list after deletion
    } catch (error) {
      debugPrint('Error deleting shop category: $error');
    }
  }

  // Set the selected category and fetch related data for the shop
  void setSelectedCategory(ShopCategory category) {
    _selectedCategory = category;
    fetchCategoriesForShop(category.shopId); // Fetch categories for the selected shop
  }

  // Clear the category filter and fetch all categories
  void clearCategoryFilter() {
    _selectedCategory = null;
    fetchShopCategories(); // Fetch all categories when filter is cleared
  }
}
