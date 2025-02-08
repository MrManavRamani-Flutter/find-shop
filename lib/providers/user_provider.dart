import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database/user_database_helper.dart';
import '../utils/shared_preferences_helper.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  User? _loggedInUser;
  User? _selectedUser;

  UserProvider() {
    fetchUsers();
  }

  //   Getters for users and loggedInUser
  List<User> get users => _users;

  User? get loggedInUser => _loggedInUser;

  User? get selectedUser => _selectedUser;

  // Fetching all users from the database
  Future<void> fetchUsers() async {
    final usersList = await UserDatabaseHelper().getUsers();
    _users = usersList;
    notifyListeners();
  }

  // Fetch a specific user by their ID and store it in selectedUser
  Future<void> fetchUserById(int userId) async {
    _selectedUser = await UserDatabaseHelper().getUserById(userId);
    notifyListeners();
  }

// Fetch a specific user by userId
  User getUserByUserId(int userId) {
    return _users.firstWhere((user) => user.userId == userId);
  }

  // Adding a new user
  Future<void> addUser(User user) async {
    await UserDatabaseHelper().insertUser(user);
    await fetchUsers();
  }

  // Updating an existing user
  Future<void> updateUser(User user) async {
    await UserDatabaseHelper().updateUser(user);
    await fetchUsers();
  }

  // In UserProvider class
  Future<void> updateUserStatus(int userId, int status) async {
    try {
      // Update user status in the database
      await UserDatabaseHelper().updateUserStatus(userId, status);

      // After updating the status, fetch the users again to reflect the changes
      await fetchUsers();

      notifyListeners(); // Notify listeners after updating the status
    } catch (e) {
      throw Exception('Error updating user status: $e');
    }
  }

  // Deleting a user by userId
  Future<void> deleteUser(int userId) async {
    await UserDatabaseHelper().deleteUser(userId);
    await fetchUsers();
  }

  // Logging in a user and storing login details in SharedPreferences
  Future<bool> loginUser(String username, String password) async {
    UserDatabaseHelper dbHelper = UserDatabaseHelper();
    User? user = await dbHelper.getUserByUsername(username);

    if (user != null && user.password == password) {
      // Store user data in SharedPreferences
      await _saveUserData(user);

      // Set logged-in user in memory
      _loggedInUser = user;
      notifyListeners();
      return true; // Login successful
    }
    return false; // Login failed
  }

  // Helper function to save user data in SharedPreferences
  Future<void> _saveUserData(User user) async {
    await SharedPreferencesHelper().saveUserData(
      userId: user.userId,
      username: user.username,
      email: user.email,
      password: user.password,
      roleId: user.roleId,
      status: user.status,
    );
    await SharedPreferencesHelper().saveLoginStatus(true); // Save login status
  }

  // Registering a new user
  Future<bool> register(String username, String email, String password,
      String contact, int roleId) async {
    UserDatabaseHelper dbHelper = UserDatabaseHelper();

    // Check if the username already exists
    User? existingUser = await dbHelper.getUserByUsername(username);
    if (existingUser != null) {
      return false; // Username already taken
    }

    // Set status based on role
    int status = (roleId == 1) ? 1 : 0;

    // Create a new user object
    User newUser = User(
      userId: DateTime.now().millisecondsSinceEpoch,
      // Temporary unique ID
      username: username,
      email: email,
      password: password,
      contact: contact,
      roleId: roleId,
      status: status,
      createdAt: DateTime.now().toString(),
    );

    // Insert the new user into the database
    await dbHelper.insertUser(newUser);
    notifyListeners();
    return true;
  }

  // Fetch the user's role from SharedPreferences
  Future<int?> getUserRoleFromPreferences() async {
    return await SharedPreferencesHelper().getUserRole();
  }

  // Fetch login status to check if the user is logged in
  Future<bool> isLoggedIn() async {
    return await SharedPreferencesHelper().isLoggedIn();
  }

  // Fetch the logged-in user from SharedPreferences and set it in memory
  Future<void> fetchLoggedInUser() async {
    bool isLoggedIn = await SharedPreferencesHelper().isLoggedIn();
    if (isLoggedIn) {
      final userId = await SharedPreferencesHelper().getUserId();
      final user = await UserDatabaseHelper().getUserById(userId!);
      _loggedInUser = user;
      notifyListeners();
    } else {
      _loggedInUser = null;
      notifyListeners();
    }
  }

  // Log out the user and clear SharedPreferences data
  Future<void> logOut() async {
    await SharedPreferencesHelper().clearUserData();
    await SharedPreferencesHelper().clearLoginStatus();

    _loggedInUser = null;
    notifyListeners(); // Notify listeners after logging out
  }
}
