import 'package:flutter/material.dart';
import '../models/shop_category.dart';
import '../database/shop_category_database_helper.dart';

class ShopCategoryProvider with ChangeNotifier {
  List<ShopCategory> _shopCategories = [];

  List<ShopCategory> get shopCategories => _shopCategories;

  Future<void> fetchShopCategories() async {
    final shopCategoriesList = await ShopCategoryDatabaseHelper().getShopCategories();
    _shopCategories = shopCategoriesList;
    notifyListeners();
  }

  Future<void> addShopCategory(ShopCategory shopCategory) async {
    await ShopCategoryDatabaseHelper().insertShopCategory(shopCategory);
    await fetchShopCategories();
  }

  Future<void> deleteShopCategory(int shopCatId) async {
    await ShopCategoryDatabaseHelper().deleteShopCategory(shopCatId);
    await fetchShopCategories();
  }
}
