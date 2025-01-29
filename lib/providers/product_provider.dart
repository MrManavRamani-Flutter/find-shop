import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/product_database_helper.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final productsList = await ProductDatabaseHelper().getProducts();
    _products = productsList;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await ProductDatabaseHelper().insertProduct(product);
    await fetchProducts();
  }

  Future<void> updateProduct(Product product) async {
    await ProductDatabaseHelper().updateProduct(product);
    await fetchProducts();
  }

  Future<void> deleteProduct(int proId) async {
    await ProductDatabaseHelper().deleteProduct(proId);
    await fetchProducts();
  }
}
