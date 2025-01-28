import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_count_model.dart';
import '../services/database_service.dart';

class UserCountProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  UserCountModel _userCounts =
      UserCountModel(customerCount: 0, shopOwnerCount: 0);

  UserCountModel get userCounts => _userCounts;

  Future<void> fetchUserCounts() async {
    final db = await _dbService.database;

    // Count customers (role_id = 1)
    final customerCount = Sqflite.firstIntValue(await db
            .rawQuery('SELECT COUNT(*) FROM users WHERE role_id = 1')) ??
        0;

    // Count shop owners (role_id = 2)
    final shopOwnerCount = Sqflite.firstIntValue(await db
            .rawQuery('SELECT COUNT(*) FROM users WHERE role_id = 2')) ??
        0;

    _userCounts = UserCountModel(
      customerCount: customerCount,
      shopOwnerCount: shopOwnerCount,
    );

    notifyListeners();
  }
}
