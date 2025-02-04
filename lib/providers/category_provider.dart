import 'package:flutter/material.dart';
import 'package:find_shop/database/category_database_helper.dart';
import 'package:find_shop/models/category.dart';

class CategoryProvider with ChangeNotifier {
  final List<Category> _categories = [];

  CategoryProvider() {
    Future.microtask(
        () => fetchCategories()); // Async call in constructor safely
  }

  List<Category> get categories => _categories;

  // Fetch categories from the database
  Future<void> fetchCategories() async {
    try {
      final categoriesList = await CategoryDatabaseHelper().getCategories();
      _categories.clear();
      _categories.addAll(categoriesList);
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching categories: $error');
    }
  }

  // Add a new category
  Future<void> addCategory(Category category) async {
    try {
      await CategoryDatabaseHelper().insertCategory(category);
      await fetchCategories();
    } catch (error) {
      debugPrint('Error adding category: $error');
    }
  }

  // Update an existing category
  Future<void> updateCategory(Category category) async {
    try {
      await CategoryDatabaseHelper().updateCategory(category);
      await fetchCategories();
    } catch (error) {
      debugPrint('Error updating category: $error');
    }
  }

  // Delete a category
  Future<void> deleteCategory(int categoryId) async {
    try {
      await CategoryDatabaseHelper().deleteCategory(categoryId);
      await fetchCategories();
    } catch (error) {
      debugPrint('Error deleting category: $error');
    }
  }
}
