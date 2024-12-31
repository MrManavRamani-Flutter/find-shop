import 'package:flutter/material.dart';

// Define the user data
final List<Map<String, String>> users = [
  {'username': 'user', 'password': '123', 'role': 'Customer'},
  {'username': 'user1', 'password': '123', 'role': 'Customer'},
  {'username': 'user2', 'password': '123', 'role': 'Customer'},
  {'username': 'shop', 'password': '123', 'role': 'ShopOwner'},
  {'username': 'shop1', 'password': '123', 'role': 'ShopOwner'},
  {'username': 'shop2', 'password': '123', 'role': 'ShopOwner'},
  {'username': 'shop3', 'password': '123', 'role': 'ShopOwner'},
  {'username': 'shop4', 'password': '123', 'role': 'ShopOwner'},
  {'username': 'admin', 'password': '123', 'role': 'Admin'},
  {'username': 'admin1', 'password': '123', 'role': 'Admin'},
  {'username': 'admin2', 'password': '123', 'role': 'Admin'},
];

// Function to handle login
Map<String, String> login(String username, String password, String role) {
  final user = users.firstWhere(
        (user) =>
    user['username'] == username &&
        user['password'] == password &&
        user['role'] == role,
    orElse: () => {},
  );
  return user;
}


// Reactive lists using ValueNotifier
final ValueNotifier<List<Map<String, dynamic>>> globalProducts = ValueNotifier([
  {
    "name": "Laptop",
    "category": "Electronics",
    "price": 999.99,
    "available": true,
    "shopName": "Tech World",
    "address": "123 Main Street, Cityville",
    "contact": "123-456-7890",
  },
  {"name": "T-Shirt", "category": "Clothing", "price": 20, "available": false},
  {
    "name": "Smartphone",
    "category": "Electronics",
    "price": 800,
    "available": true
  },
  {"name": "Table", "category": "Furniture", "price": 150, "available": true},
]);

final ValueNotifier<List<Map<String, dynamic>>> globalServices = ValueNotifier([
  {"name": "Plumbing", "price": 50, "available": true,
    "shopName": "Tech World",
    "address": "123 Main Street, Cityville",
    "contact": "123-456-7890",},

  {"name": "Electrical Repair", "price": 70, "available": false},
  {"name": "Cleaning", "price": 30, "available": true},
  {"name": "Gardening", "price": 40, "available": true},
]);

// Functions to modify products
void addProduct(Map<String, dynamic> product) {
  globalProducts.value = [...globalProducts.value, product];
}

void removeProduct(int index) {
  final updatedList = List<Map<String, dynamic>>.from(globalProducts.value);
  updatedList.removeAt(index);
  globalProducts.value = updatedList;
}

// Functions to modify services
void addService(Map<String, dynamic> service) {
  globalServices.value = [...globalServices.value, service];
}

void removeService(int index) {
  final updatedList = List<Map<String, dynamic>>.from(globalServices.value);
  updatedList.removeAt(index);
  globalServices.value = updatedList;
}
