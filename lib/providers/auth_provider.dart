import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/tables/role_service.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  late final RoleService _roleService;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  // Constructor with initialization
  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    final db = await _dbService.database;
    _roleService = RoleService(db);
    notifyListeners(); // Notify listeners after initialization
  }

  // Fetch roles from the database using RoleService
  Future<List<Map<String, dynamic>>> fetchRoles() async {
    if (_roleService.toString().isEmpty) {
      await _initialize();
    }
    return await _roleService.getRoles();
  }


  // Register user and insert into database
  Future<bool> registerUser(String username, String email, String password,
      String contact, int roleId) async {
    final db = await _dbService.database;

    final existingUser =
        await db.query('users', where: 'email = ?', whereArgs: [email]);

    if (existingUser.isNotEmpty) {
      return false; // Email already exists
    }

    final newUser = {
      'username': username,
      'email': email,
      'password': password,
      'contact': contact,
      'role_id': roleId,
      'status': (roleId == 2 || roleId == 3) ? 0 : 1, // Status based on role
      'created_at': DateTime.now().toIso8601String(),
    };

    await db.insert('users', newUser);
    return true;
  }

  // Login user by verifying email and password
  Future<bool> login(String email, String password) async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      final data = result.first;
      _currentUser = UserModel(
        userId: data['user_id'] as int?,
        username: data['username'] as String,
        email: data['email'] as String,
        password: data['password'] as String,
        contact: data['contact'] as String,
        roleId: data['role_id'] as int,
        status: data['status'] as int,
        createdAt: data['created_at'] as String,
      );

      // Store user data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', _currentUser!.userId!);
      await prefs.setString('username', _currentUser!.username);
      await prefs.setString('email', _currentUser!.email);
      await prefs.setInt('role_id', _currentUser!.roleId);

      notifyListeners();
      return true;
    }
    return false;
  }

  // Check if user is already logged in using SharedPreferences
  Future<void> checkLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user_id')) {
      _currentUser = UserModel(
        userId: prefs.getInt('user_id'),
        username: prefs.getString('username') ?? '',
        email: prefs.getString('email') ?? '',
        password: '',
        contact: '',
        roleId: prefs.getInt('role_id') ?? 0,
        status: 1,
        // Set status to 1 by default
        createdAt: '',
      );
      notifyListeners();
    }
  }

  // Logout user and clear SharedPreferences
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear saved user data
    _currentUser = null; // Reset current user
    notifyListeners();
  }

  // Insert default roles when the app is first opened
  Future<void> insertDefaultRoles() async {
    try {
      await _roleService.insertDefaultRoles(); // Insert default roles if needed
    } catch (e) {
      throw Exception("Failed to insert default roles: $e");
    }
  }
}
