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

      // If a user is found, return the user object
      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      } else {
        return null; // Return null if user is not found
      }
    } catch (e) {
      throw Exception('Error fetching user by ID: $e');
    }
  }

  // Update an existing user in the database
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

  // Update the user's status in the database
  Future<int> updateUserStatus(int userId, int status) async {
    final db = await AppDatabase().database;
    try {
      return await db.update(
        tableName,
        {'status': status}, // Update only the status column
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

  // Fetch a user by their username
  Future<User?> getUserByUsername(String username) async {
    final db = await AppDatabase().database;
    try {
      final result = await db.query(
        tableName,
        where: 'username = ?',
        whereArgs: [username],
      );

      // If user is found, return the user object
      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      } else {
        return null; // Return null if no user found
      }
    } catch (e) {
      throw Exception('Error fetching user by username: $e');
    }
  }
}
