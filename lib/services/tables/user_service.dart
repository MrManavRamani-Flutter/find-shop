import 'package:sqflite/sqflite.dart';
import '../../models/user_model.dart';

class UserService {
  final Database db;

  UserService(this.db);

  // Create users table
  Future<void> createUsersTable() async {
    await db.execute('''
      CREATE TABLE users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        contact TEXT NOT NULL,
        role_id INTEGER NOT NULL,
        status INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE
      )
    ''');
  }

  // Insert a user
  Future<int> insertUser(Map<String, dynamic> user) async {
    return await db.insert('users', user);
  }

  // Fetch all Shop Owners (role_id = 2)
  Future<List<UserModel>> getShopOwners() async {
    final List<Map<String, dynamic>> shopOwners = await db.query(
      'users',
      where: 'role_id = ?',
      whereArgs: [2],
    );
    return shopOwners.map((owner) => UserModel.fromMap(owner)).toList();
  }

  // Update a Shop Owner's status
  Future<void> updateShopOwnerStatus(int id, int status) async {
    await db.update(
      'users',
      {'status': status},
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }
}
