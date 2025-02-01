import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database/user_database_helper.dart';
import '../utils/shared_preferences_helper.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  User? _loggedInUser;

  UserProvider() {
    fetchUsers();
  }

  List<User> get users => _users;
  User? get loggedInUser => _loggedInUser;

  Future<void> fetchUsers() async {
    _users = await UserDatabaseHelper().getUsers();
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    await UserDatabaseHelper().insertUser(user);
    await fetchUsers();
  }

  Future<void> updateUser(User user) async {
    await UserDatabaseHelper().updateUser(user);
    await fetchUsers();
  }

  Future<void> deleteUser(int userId) async {
    await UserDatabaseHelper().deleteUser(userId);
    await fetchUsers();
  }

  Future<bool> loginUser(String username, String password) async {
    UserDatabaseHelper dbHelper = UserDatabaseHelper();
    User? user = await dbHelper.getUserByUsername(username);

    if (user != null && user.password == password) {
      await _saveUserData(user);
      _loggedInUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> _saveUserData(User user) async {
    await SharedPreferencesHelper().saveUserData(
      userId: user.userId,
      username: user.username,
      email: user.email,
      password: user.password,
      roleId: user.roleId,
      status: user.status,
    );
    await SharedPreferencesHelper().saveLoginStatus(true);
  }

  Future<bool> register(String username, String email, String password, String contact, int roleId) async {
    UserDatabaseHelper dbHelper = UserDatabaseHelper();

    User? existingUser = await dbHelper.getUserByUsername(username);
    if (existingUser != null) {
      return false;
    }

    int status = (roleId == 1) ? 1 : 0;

    User newUser = User(
      userId: DateTime.now().millisecondsSinceEpoch,
      username: username,
      email: email,
      password: password,
      contact: contact,
      roleId: roleId,
      status: status,
      createdAt: DateTime.now().toString(),
    );

    await dbHelper.insertUser(newUser);
    notifyListeners();
    return true;
  }

  Future<int?> getUserRoleFromPreferences() async {
    return await SharedPreferencesHelper().getUserRole();
  }

  Future<bool> isLoggedIn() async {
    return await SharedPreferencesHelper().isLoggedIn();
  }

  Future<void> fetchLoggedInUser() async {
    bool isLoggedIn = await SharedPreferencesHelper().isLoggedIn();
    if (isLoggedIn) {
      final userId = await SharedPreferencesHelper().getUserId();
      _loggedInUser = await UserDatabaseHelper().getUserById(userId!);
      notifyListeners();
    } else {
      _loggedInUser = null;
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    await SharedPreferencesHelper().clearUserData();
    await SharedPreferencesHelper().clearLoginStatus();
    _loggedInUser = null;
    notifyListeners();
  }
}
