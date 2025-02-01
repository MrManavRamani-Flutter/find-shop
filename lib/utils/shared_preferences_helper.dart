import 'package:find_shop/database/user_database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _keyUserId = 'user_id';
  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyPassword = 'password';
  static const _keyRoleId = 'role_id';
  static const _keyUserStatus = 'user_status';
  static const _keyAuthToken = 'auth_token';
  static const _keyLoggedIn = 'logged_in';

  // Save user data to SharedPreferences
  Future<void> saveUserData({
    required int userId,
    required String username,
    required String email,
    required String password,
    required int roleId,
    required int status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
    await prefs.setInt(_keyRoleId, roleId);
    await prefs.setInt(_keyUserStatus, status);
  }

  Future<void> updateUserStatus(int status) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId != null) {
      // Update status in database
      await UserDatabaseHelper().updateUserStatus(userId, status);

      // Update status in shared preferences
      await prefs.setInt('user_status', status);
    }
  }

  // Save authentication token to SharedPreferences
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, token);
  }

  // Save login status to SharedPreferences
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, isLoggedIn);
  }

  // Get user ID from SharedPreferences
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  // Get user role
  Future<int?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyRoleId);
  }

  // Get user status
  Future<int?> getUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserStatus);
  }

  // Get user username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // Get user email
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // Get user password
  Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword);
  }

  // Clear all user data
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyRoleId);
    await prefs.remove(_keyUserStatus);
  }

  // Clear authentication token
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuthToken);
  }

  // Clear login status
  Future<void> clearLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
  }
}
