import 'package:flutter/material.dart';
import 'package:find_shop/database/category_database_helper.dart';
import 'package:find_shop/models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  // Constructor to fetch categories upon initialization
  CategoryProvider() {
    fetchCategories();
  }

  List<Category> get categories => _categories;

  // Fetch categories from the database
  Future<void> fetchCategories() async {
    final categoriesList = await CategoryDatabaseHelper().getCategories();
    _categories = categoriesList;
    notifyListeners();
  }

  // Add a new category
  Future<void> addCategory(Category category) async {
    await CategoryDatabaseHelper().insertCategory(category);
    await fetchCategories(); // Refresh the category list
  }

  // Update an existing category
  Future<void> updateCategory(Category category) async {
    await CategoryDatabaseHelper().updateCategory(category);
    await fetchCategories(); // Refresh the category list
  }

  // Delete a category
  Future<void> deleteCategory(int categoryId) async {
    await CategoryDatabaseHelper().deleteCategory(categoryId);
    await fetchCategories(); // Refresh the category list
  }
}
