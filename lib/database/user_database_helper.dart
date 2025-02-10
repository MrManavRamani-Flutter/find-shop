import 'app_database.dart';
import '../models/user.dart';

class UserDatabaseHelper {
  static const String tableName = 'users';

  // Insert a new user into the database
  Future<int> insertUser(User user) async {
    final db = await AppDatabase().database;
    try {
      return await db.insert(tableName, user.toMap());
    } catch (e) {
      throw Exception('Error inserting user: $e');
    }
  }

  // Fetch all users from the database
  Future<List<User>> getUsers() async {
    final db = await AppDatabase().database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(tableName);
      return List.generate(maps.length, (i) {
        return User.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Fetch a user by their ID
  Future<User?> getUserById(int userId) async {
    final db = await AppDatabase().database;
    try {
      final result = await db.query(
        tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      return result.isNotEmpty ? User.fromMap(result.first) : null;
    } catch (e) {
      throw Exception('Error fetching user by ID: $e');
    }
  }

  // Update an existing user's details
  Future<int> updateUser(User user) async {
    final db = await AppDatabase().database;
    try {
      return await db.update(
        tableName,
        user.toMap(),
        where: 'user_id = ?',
        whereArgs: [user.userId],
      );
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Update only the user's status
  Future<int> updateUserStatus(int userId, int status) async {
    final db = await AppDatabase().database;
    try {
      return await db.update(
        tableName,
        {'status': status},
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      throw Exception('Error updating user status: $e');
    }
  }

  // Delete a user by their ID
  Future<int> deleteUser(int userId) async {
    final db = await AppDatabase().database;
    try {
      return await db.delete(
        tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  // Fetch a user by their username or email
  Future<User?> getUserByUsername(String username) async {
    final db = await AppDatabase().database;
    try {
      final result = await db.query(
        tableName,
        where: 'username = ? OR email = ?',
        whereArgs: [username, username],
      );

      return result.isNotEmpty ? User.fromMap(result.first) : null;
    } catch (e) {
      throw Exception('Error fetching user by username or email: $e');
    }
  }
}
