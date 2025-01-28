import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'find_shop.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create roles table
        await db.execute('''
          CREATE TABLE roles (
            role_id INTEGER PRIMARY KEY AUTOINCREMENT,
            role_name TEXT NOT NULL UNIQUE
          )
        ''');

        // Create users table
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

        // Insert default roles
        const defaultRoles = [
          {'role_name': 'Customer'},
          {'role_name': 'Shop Owner'},
          {'role_name': 'Admin'},
        ];
        for (var role in defaultRoles) {
          await db.insert('roles', role);
        }
      },
    );
  }

  Future<int> insertRole(String roleName) async {
    final db = await database;
    return await db.insert('roles', {'role_name': roleName});
  }

  Future<List<Map<String, dynamic>>> getRoles() async {
    final db = await database;
    return await db.query('roles');
  }

  Future<List<UserModel>> getShopOwners() async {
    final db = await database;

    // Fetch all users with role_id corresponding to "Shop Owner"
    final List<Map<String, dynamic>> shopOwners = await db.query(
      'users',
      where: 'role_id = ?',
      whereArgs: [2], // Assuming 2 is the role_id for "Shop Owner"
    );

    // Convert the database rows into a list of UserModel objects
    return shopOwners.map((owner) => UserModel.fromMap(owner)).toList();
  }

  Future<void> updateShopOwnerStatus(int id, int status) async {
    final db = await database;
    await db.update(
      'users',
      {'status': status},
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }
}
