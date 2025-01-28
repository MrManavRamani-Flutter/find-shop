import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class ShopOwnerProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<UserModel> _shopOwners = [];
  bool _isLoading = false;

  List<UserModel> get shopOwners => _shopOwners;
  bool get isLoading => _isLoading;

  // Fetches the list of shop owners from the database
  Future<void> fetchShopOwners() async {
    _setLoading(true);

    try {
      _shopOwners = await _databaseService.getShopOwners();
    } catch (error) {
      debugPrint("Error fetching shop owners: $error");
    } finally {
      _setLoading(false);
    }
  }

  // Fetches a single shop owner by their ID
  UserModel? getShopOwnerById(int id) {
    return _shopOwners.firstWhere(
          (owner) => owner.userId == id,
      orElse: () => UserModel(username: 'username', email: 'email', password: 'password', contact: '1234567890', roleId: 0, status: 0, createdAt: '00/00/0000 00:00:00'), // If no owner is found, return null
    );
  }

  // Updates the shop owner's status and refreshes the list
  Future<void> updateShopOwnerStatus(int id, int status) async {
    try {
      await _databaseService.updateShopOwnerStatus(id, status);

      // Find and update the status locally in the list
      final index = _shopOwners.indexWhere((owner) => owner.userId == id);
      if (index != -1) {
        _shopOwners[index].status = status;
        notifyListeners(); // Notify listeners after updating the list
      }
    } catch (error) {
      debugPrint("Error updating shop owner status: $error");
    }
  }

  // Private helper method to manage loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
