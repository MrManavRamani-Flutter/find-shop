import 'package:flutter/material.dart';
import '../models/category.dart';
import '../database/category_database_helper.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    final categoriesList = await CategoryDatabaseHelper().getCategories();
    _categories = categoriesList;
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await CategoryDatabaseHelper().insertCategory(category);
    await fetchCategories();
  }

  Future<void> updateCategory(Category category) async {
    await CategoryDatabaseHelper().updateCategory(category);
    await fetchCategories();
  }

  Future<void> deleteCategory(int categoryId) async {
    await CategoryDatabaseHelper().deleteCategory(categoryId);
    await fetchCategories();
  }
}
