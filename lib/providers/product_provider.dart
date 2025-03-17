import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/product_database_helper.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = []; // List to hold filtered products
  int _productCountByShopId = 0;

  List<Product> get products => _products;

  List<Product> get filteredProducts => _filteredProducts;
  List<Map<String, dynamic>> _productShopUserData = [];

  List<Map<String, dynamic>> get productShopUserData => _productShopUserData;

  int get productCountByShopId => _productCountByShopId;

  // Fetch product with shop and user details by productId
  Future<void> fetchProductShopUserData(int productId) async {
    final productShopUserData =
        await ProductDatabaseHelper().getUserAndShopByProductId(productId);
    _productShopUserData =
        productShopUserData != null ? [productShopUserData] : [];
    notifyListeners();
  }

  // Fetch all products from the database
  Future<void> fetchProducts() async {
    final productsList = await ProductDatabaseHelper().getProducts();
    _products = productsList;
    _filteredProducts = [
      ..._products
    ]; // Initialize filtered products with all products
    notifyListeners();
  }

  // Search products based on the query
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = [..._products];
    } else {
      _filteredProducts = _products.where((product) {
        return product.proName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // Fetch products by shop_id from the database
  Future<void> fetchProductsByShopId(int shopId) async {
    final productsList =
        await ProductDatabaseHelper().getProductsByShopId(shopId);
    _products = productsList;
    _filteredProducts = [..._products];
    notifyListeners();
  }

  // Get the product count by shop_id
  Future<void> countProductsByShopId(int shopId) async {
    _productCountByShopId =
        await ProductDatabaseHelper().countProductsByShopId(shopId);
    notifyListeners();
  }

  // Add a new product and fetch products based on shop ID
  Future<void> addProduct(Product product) async {
    await ProductDatabaseHelper().insertProduct(product);
    await fetchProductsByShopId(
        product.shopId); // Fetch updated product list for the shop
  }

  // Update an existing product and fetch products by shop ID
  Future<void> updateProduct(Product product) async {
    await ProductDatabaseHelper().updateProduct(product);
    await fetchProductsByShopId(
        product.shopId); // Fetch updated product list for the shop
  }

  // Delete a product by its ID
  Future<void> deleteProduct(int proId) async {
    await ProductDatabaseHelper().deleteProduct(proId);
    await fetchProducts(); // Refresh the product list after deletion
  }
}
