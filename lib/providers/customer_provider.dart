import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class CustomerProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<UserModel> _customers = [];
  bool _isLoading = false;

  List<UserModel> get customers => _customers;

  bool get isLoading => _isLoading;

  /// Fetch all customers from the database
  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners();

    final db = await _dbService.database;

    try {
      // Fetch customers (role_id = 1)
      final List<Map<String, dynamic>> customerList = await db.query(
        'users',
        where: 'role_id = ?',
        whereArgs: [1], // Assuming role_id = 1 represents "Customer"
      );

      // Map database rows to UserModel instances
      _customers = customerList.map((data) => UserModel.fromMap(data)).toList();
    } catch (error) {
      debugPrint('Error fetching customers: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get a specific customer by their ID
  UserModel? getCustomerById(int customerId) {
    try {
      return _customers.firstWhere((customer) => customer.userId == customerId);
    } catch (error) {
      debugPrint('Customer with ID $customerId not found: $error');
      return null;
    }
  }

  /// Update the status of a specific customer
  Future<void> updateCustomerStatus(int customerId, int newStatus) async {
    final db = await _dbService.database;

    try {
      // Update the customer's status in the database
      await db.update(
        'users',
        {'status': newStatus},
        where: 'user_id = ?',
        whereArgs: [customerId],
      );

      // Update the local customer list
      final customerIndex =
          _customers.indexWhere((customer) => customer.userId == customerId);

      if (customerIndex != -1) {
        _customers[customerIndex].status = newStatus;
        notifyListeners();
      }
    } catch (error) {
      debugPrint('Error updating customer status: $error');
    }
  }
}
