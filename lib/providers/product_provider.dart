import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/product_database_helper.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];  // Add a list to hold filtered products
  int _productCountByShopId = 0;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;  // Expose filtered products

  int get productCountByShopId => _productCountByShopId;

  // Fetch all products
  Future<void> fetchProducts() async {
    final productsList = await ProductDatabaseHelper().getProducts();
    _products = productsList;
    _filteredProducts = [..._products];  // Initialize filtered products with all products
    notifyListeners();
  }

  // Search products based on query
  void searchProducts(String query) {
    if (query.isEmpty) {
      // If the search query is empty, reset the filtered list to all products
      _filteredProducts = [..._products];
    } else {
      // Filter the products based on the search query
      _filteredProducts = _products.where((product) {
        return product.proName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();  // Notify listeners to update the UI
  }

  // Fetch products by shop_id
  Future<void> fetchProductsByShopId(int shopId) async {
    final productsList = await ProductDatabaseHelper().getProductsByShopId(shopId);
    _products = productsList;
    _filteredProducts = [..._products];  // Reset filtered list
    notifyListeners();
  }

  // Get product count by shop_id
  Future<void> countProductsByShopId(int shopId) async {
    _productCountByShopId = await ProductDatabaseHelper().countProductsByShopId(shopId);
    notifyListeners(); // Notify listeners so UI updates
  }

  // Add a new product
  Future<void> addProduct(Product product) async {
    await ProductDatabaseHelper().insertProduct(product);
    await fetchProducts();  // Refresh the product list
  }

  // Update an existing product
  Future<void> updateProduct(Product product) async {
    await ProductDatabaseHelper().updateProduct(product);
    await fetchProducts();  // Refresh the product list
  }

  // Delete a product by its ID
  Future<void> deleteProduct(int proId) async {
    await ProductDatabaseHelper().deleteProduct(proId);
    await fetchProducts();  // Refresh the product list
  }
}
