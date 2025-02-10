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
    await prefs.setInt(_keyUserId, userId); // Save user ID
    await prefs.setString(_keyUsername, username); // Save username
    await prefs.setString(_keyEmail, email); // Save email
    await prefs.setString(_keyPassword, password); // Save password
    await prefs.setInt(_keyRoleId, roleId); // Save role ID
    await prefs.setInt(_keyUserStatus, status); // Save user status
  }

  // Update user status both in SharedPreferences and database
  Future<void> updateUserStatus(int status) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id'); // Get user ID from SharedPreferences

    if (userId != null) {
      await UserDatabaseHelper()
          .updateUserStatus(userId, status); // Update status in database
      await prefs.setInt(
          'user_status', status); // Update status in SharedPreferences
    }
  }

  // Save authentication token to SharedPreferences
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _keyAuthToken, token); // Save token for authentication
  }

  // Save login status to SharedPreferences
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        _keyLoggedIn, isLoggedIn); // Save login status (true/false)
  }

  // Get user ID from SharedPreferences
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId); // Return user ID
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false; // Check if user is logged in
  }

  // Get user role from SharedPreferences
  Future<int?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyRoleId); // Return user role
  }

  // Get user status from SharedPreferences
  Future<int?> getUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserStatus); // Return user status
  }

  // Get user username from SharedPreferences
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername); // Return username
  }

  // Get user email from SharedPreferences
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail); // Return email
  }

  // Get user password from SharedPreferences
  Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword); // Return password
  }

  // Clear all user data from SharedPreferences
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId); // Remove user ID
    await prefs.remove(_keyUsername); // Remove username
    await prefs.remove(_keyEmail); // Remove email
    await prefs.remove(_keyPassword); // Remove password
    await prefs.remove(_keyRoleId); // Remove role ID
    await prefs.remove(_keyUserStatus); // Remove user status
  }

  // Clear authentication token from SharedPreferences
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuthToken); // Remove auth token
  }

  // Clear login status from SharedPreferences
  Future<void> clearLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn); // Remove login status
  }
}
