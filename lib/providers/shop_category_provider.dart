import 'package:flutter/material.dart';
import '../models/shop_category.dart';
import '../database/shop_category_database_helper.dart';

class ShopCategoryProvider with ChangeNotifier {
  List<ShopCategory> _shopCategories = [];
  ShopCategory? _selectedCategory; // Track the selected category for filtering

  List<ShopCategory> get shopCategories => _shopCategories;
  ShopCategory? get selectedCategory => _selectedCategory;

  // Fetch all shop categories from the database
  Future<void> fetchShopCategories() async {
    final shopCategoryList = await ShopCategoryDatabaseHelper().getShopCategories();
    _shopCategories = shopCategoryList;
    notifyListeners();
  }

  // Fetch categories based on the selected shopId
  Future<void> fetchCategoriesForShop(int shopId) async {
    _shopCategories = _shopCategories.where((shopCategory) => shopCategory.shopId == shopId).toList();
    notifyListeners();
  }

  // Add a new shop category and fetch the updated list of categories
  Future<int> addShopCategory(ShopCategory shopCategory) async {
    final shopCatId = await ShopCategoryDatabaseHelper().insertShopCategory(shopCategory);
    await fetchShopCategories();
    return shopCatId;
  }

  // Update an existing shop category and fetch the updated list of categories
  Future<void> updateShopCategory(ShopCategory shopCategory) async {
    await ShopCategoryDatabaseHelper().updateShopCategory(shopCategory);
    await fetchShopCategories();
  }

  // Delete a shop category and fetch the updated list of categories
  Future<void> deleteShopCategory(int shopCatId) async {
    await ShopCategoryDatabaseHelper().deleteShopCategory(shopCatId);
    await fetchShopCategories();
  }

  // Set the selected category and notify listeners
  void setSelectedCategory(ShopCategory category) {
    _selectedCategory = category;
    fetchCategoriesForShop(category.shopId); // Fetch categories for the selected shop
    notifyListeners();
  }

  // Clear the category filter
  void clearCategoryFilter() {
    _selectedCategory = null;
    fetchShopCategories(); // Show all categories when no category is selected
    notifyListeners();
  }
}
