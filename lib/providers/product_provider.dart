import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/product_database_helper.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = []; // List to hold filtered products
  int _productCountByShopId = 0;

  List<Product> get products => _products;

  List<Product> get filteredProducts =>
      _filteredProducts; // Expose filtered products
  List<Map<String, dynamic>> _productShopUserData = [];

  List<Map<String, dynamic>> get productShopUserData => _productShopUserData;

  int get productCountByShopId => _productCountByShopId;

  // Fetch product with shop and user details by productId
  Future<void> fetchProductShopUserData(int productId) async {
    final productShopUserData =
    await ProductDatabaseHelper().getUserAndShopByProductId(productId);
    if (productShopUserData != null) {
      _productShopUserData = [productShopUserData]; // Store the data
    } else {
      _productShopUserData = [];
    }
    notifyListeners(); // Notify listeners to update the UI
  }

  // Fetch all products from the database
  Future<void> fetchProducts() async {
    final productsList = await ProductDatabaseHelper().getProducts();
    _products = productsList;
    _filteredProducts = [
      ..._products
    ]; // Initialize filtered products with all products
    notifyListeners(); // Notify listeners to update the UI
  }

  // Search products based on the query
  void searchProducts(String query) {
    if (query.isEmpty) {
      // If query is empty, reset filtered list to all products
      _filteredProducts = [..._products];
    } else {
      // Filter products based on the search query
      _filteredProducts = _products.where((product) {
        return product.proName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners(); // Notify listeners to update the UI
  }

  // Fetch products by shop_id from the database
  Future<void> fetchProductsByShopId(int shopId) async {
    final productsList =
    await ProductDatabaseHelper().getProductsByShopId(shopId);
    _products = productsList;
    _filteredProducts = [..._products]; // Reset filtered list
    notifyListeners(); // Notify listeners to update the UI
  }

  // Get the product count by shop_id
  Future<void> countProductsByShopId(int shopId) async {
    _productCountByShopId =
    await ProductDatabaseHelper().countProductsByShopId(shopId);
    notifyListeners(); // Notify listeners to update the UI
  }

  // Add a new product to the database
  Future<void> addProduct(Product product) async {
    await ProductDatabaseHelper().insertProduct(product);
    await fetchProducts(); // Refresh the product list after adding
  }

  // Update an existing product in the database
  Future<void> updateProduct(Product product) async {
    await ProductDatabaseHelper().updateProduct(product);
    await fetchProducts(); // Refresh the product list after update
  }

  // Delete a product by its ID
  Future<void> deleteProduct(int proId) async {
    await ProductDatabaseHelper().deleteProduct(proId);
    await fetchProducts(); // Refresh the product list after deletion
  }
}
