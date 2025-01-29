import 'app_database.dart';
import '../models/user.dart';

class UserDatabaseHelper {
  static const String tableName = 'users';

  Future<int> insertUser(User user) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<User?> getUserById(int userId) async {
    final db = await AppDatabase().database;

    // Query the database to fetch the user with the specified userId
    final result = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    // Check if a user was found
    if (result.isNotEmpty) {
      // If found, return the user by mapping the result to the User model
      return User.fromMap(result.first);
    } else {
      // If no user found, return null
      return null;
    }
  }

  Future<int> updateUser(User user) async {
    final db = await AppDatabase().database;
    return await db.update(
      tableName,
      user.toMap(),
      where: 'user_id = ?',
      whereArgs: [user.userId],
    );
  }

  Future<int> deleteUser(int userId) async {
    final db = await AppDatabase().database;
    return await db.delete(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await AppDatabase().database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
}
