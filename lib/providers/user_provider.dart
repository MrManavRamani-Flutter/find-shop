import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database/user_database_helper.dart';
import '../utils/shared_preferences_helper.dart'; // Importing SharedPreferencesHelper

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  User? _loggedInUser; // Declare the _loggedInUser variable to store the logged-in user

  List<User> get users => _users;
  User? get loggedInUser => _loggedInUser; // Getter for loggedInUser

  // Fetching users from the database
  Future<void> fetchUsers() async {
    final usersList = await UserDatabaseHelper().getUsers();
    _users = usersList;
    notifyListeners();
  }

  // Adding a user
  Future<void> addUser(User user) async {
    await UserDatabaseHelper().insertUser(user);
    await fetchUsers();
  }

  // Updating a user
  Future<void> updateUser(User user) async {
    await UserDatabaseHelper().updateUser(user);
    await fetchUsers();
  }

  // Deleting a user
  Future<void> deleteUser(int userId) async {
    await UserDatabaseHelper().deleteUser(userId);
    await fetchUsers();
  }

  // Logging in a user
  Future<bool> loginUser(String username, String password) async {
    UserDatabaseHelper dbHelper = UserDatabaseHelper();
    User? user = await dbHelper.getUserByUsername(username);

    if (user != null && user.password == password) {
      // Store user data in SharedPreferences after successful login
      await SharedPreferencesHelper().saveUserData(
        userId: user.userId,
        username: user.username,
        email: user.email,
        password: user.password,
        roleId: user.roleId,
        status: user.status,
      );
      // Store authentication token if required
      await SharedPreferencesHelper().saveLoginStatus(true);

      // Set the logged-in user in memory
      _loggedInUser = user;
      notifyListeners(); // Notify listeners about the change
      return true; // Login successful
    }

    return false; // Login failed
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

    // Set status based on role (1 = Customer, 2 = Shop Owner, 3 = Admin)
    int status = (roleId == 1) ? 1 : 0;

    // Create new user object
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

    // Insert user into the database
    await dbHelper.insertUser(newUser);
    notifyListeners();
    return true;
  }

  // Fetch the user's role from SharedPreferences (for navigating post-login)
  Future<int?> getUserRoleFromPreferences() async {
    return await SharedPreferencesHelper().getUserRole();
  }

  // Fetch login status
  Future<bool> isLoggedIn() async {
    return await SharedPreferencesHelper().isLoggedIn();
  }

  // Fetching the logged-in user from SharedPreferences
  Future<void> fetchLoggedInUser() async {
    bool isLoggedIn = await SharedPreferencesHelper().isLoggedIn();
    if (isLoggedIn) {
      // Retrieve the user ID or other necessary data from SharedPreferences
      final userId = await SharedPreferencesHelper().getUserId();
      final user = await UserDatabaseHelper().getUserById(userId!);
      _loggedInUser = user;
      notifyListeners(); // Notify listeners about the change
    } else {
      _loggedInUser = null; // If not logged in, set it to null
      notifyListeners(); // Notify listeners about the change
    }
  }

  // Log out the user
  Future<void> logOut() async {
    await SharedPreferencesHelper().clearUserData();
    await SharedPreferencesHelper().clearLoginStatus();

    // Set the logged-in user to null
    _loggedInUser = null;
    notifyListeners(); // Notify listeners after logging out
  }
}
