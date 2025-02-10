import 'package:flutter/material.dart';
import 'package:find_shop/database/category_database_helper.dart';
import 'package:find_shop/models/category.dart';

class CategoryProvider with ChangeNotifier {
  final List<Category> _categories = [];

  // Constructor to fetch categories asynchronously when the provider is initialized
  CategoryProvider() {
    Future.microtask(
            () => fetchCategories()); // Async call in constructor safely
  }

  // Getter to retrieve the list of categories
  List<Category> get categories => _categories;

  // Fetch categories from the database and update the list
  Future<void> fetchCategories() async {
    try {
      final categoriesList = await CategoryDatabaseHelper().getCategories();
      _categories.clear();
      _categories.addAll(categoriesList);
      notifyListeners(); // Notify listeners when the categories are updated
    } catch (error) {
      debugPrint('Error fetching categories: $error');
    }
  }

  // Adds a new category to the database and refreshes the categories list
  Future<void> addCategory(Category category) async {
    try {
      await CategoryDatabaseHelper().insertCategory(category);
      await fetchCategories(); // Refresh the categories list after adding
    } catch (error) {
      debugPrint('Error adding category: $error');
    }
  }

  // Updates an existing category in the database and refreshes the categories list
  Future<void> updateCategory(Category category) async {
    try {
      await CategoryDatabaseHelper().updateCategory(category);
      await fetchCategories(); // Refresh the categories list after updating
    } catch (error) {
      debugPrint('Error updating category: $error');
    }
  }

  // Deletes a category by its ID and refreshes the categories list
  Future<void> deleteCategory(int categoryId) async {
    try {
      await CategoryDatabaseHelper().deleteCategory(categoryId);
      await fetchCategories(); // Refresh the categories list after deleting
    } catch (error) {
      debugPrint('Error deleting category: $error');
    }
  }
}
