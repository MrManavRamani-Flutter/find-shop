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

  // Getters for users, loggedInUser, and selectedUser
  List<User> get users => _users;
  User? get loggedInUser => _loggedInUser;
  User? get selectedUser => _selectedUser;

  // Fetch all users from the database
  Future<void> fetchUsers() async {
    final usersList = await UserDatabaseHelper().getUsers();
    _users = usersList;
    notifyListeners(); // Notify listeners to update UI
  }

  // Fetch a specific user by their ID and store it in selectedUser
  Future<void> fetchUserById(int userId) async {
    _selectedUser = await UserDatabaseHelper().getUserById(userId);
    notifyListeners(); // Notify listeners to update UI
  }

  // Fetch a user by userId from the list of users
  User getUserByUserId(int userId) {
    return _users.firstWhere((user) => user.userId == userId);
  }

  // Add a new user to the database
  Future<void> addUser(User user) async {
    await UserDatabaseHelper().insertUser(user);
    await fetchUsers(); // Refresh user list after adding a new user
  }

  // Update an existing user in the database
  Future<void> updateUser(User user) async {
    await UserDatabaseHelper().updateUser(user);
    await fetchUsers(); // Refresh user list after updating the user
  }

  // Update the status of a user
  Future<void> updateUserStatus(int userId, int status) async {
    try {
      // Update user status in the database
      await UserDatabaseHelper().updateUserStatus(userId, status);
      await fetchUsers(); // Refresh user list after updating status
      notifyListeners(); // Notify listeners after updating the status
    } catch (e) {
      throw Exception('Error updating user status: $e');
    }
  }

  // Delete a user from the database
  Future<void> deleteUser(int userId) async {
    await UserDatabaseHelper().deleteUser(userId);
    await fetchUsers(); // Refresh user list after deletion
  }

  // Log in a user by verifying their username and password
  Future<bool> loginUser(String username, String password) async {
    UserDatabaseHelper dbHelper = UserDatabaseHelper();
    User? user = await dbHelper.getUserByUsername(username);

    if (user != null && user.password == password) {
      // Save user data in SharedPreferences after successful login
      await _saveUserData(user);
      _loggedInUser = user;
      notifyListeners(); // Notify listeners to update logged-in user
      return true; // Login successful
    }
    return false; // Login failed
  }

  // Save user data in SharedPreferences after login
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

  // Register a new user and add them to the database
  Future<bool> register(String username, String email, String password,
      String contact, int roleId) async {
    UserDatabaseHelper dbHelper = UserDatabaseHelper();

    // Check if the username already exists
    User? existingUser = await dbHelper.getUserByUsername(username);
    if (existingUser != null) {
      return false; // Username already taken
    }

    // Set status based on role (1 for active, 0 for inactive)
    int status = (roleId == 1) ? 1 : 0;

    // Create a new user object
    User newUser = User(
      userId: DateTime.now().millisecondsSinceEpoch, // Temporary unique ID
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
    notifyListeners(); // Notify listeners after adding a new user
    return true; // Registration successful
  }

  // Fetch the user's role from SharedPreferences
  Future<int?> getUserRoleFromPreferences() async {
    return await SharedPreferencesHelper().getUserRole();
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    return await SharedPreferencesHelper().isLoggedIn();
  }

  // Fetch the logged-in user's data from SharedPreferences and set it in memory
  Future<void> fetchLoggedInUser() async {
    bool isLoggedIn = await SharedPreferencesHelper().isLoggedIn();
    if (isLoggedIn) {
      final userId = await SharedPreferencesHelper().getUserId();
      final user = await UserDatabaseHelper().getUserById(userId!);
      _loggedInUser = user;
      notifyListeners(); // Notify listeners after fetching logged-in user
    } else {
      _loggedInUser = null;
      notifyListeners(); // Notify listeners if user is not logged in
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
