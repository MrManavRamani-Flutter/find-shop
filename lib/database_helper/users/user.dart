import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/user_model/user.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE users ('
                'user_id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'username TEXT, '
                'email TEXT, '
                'password TEXT, '
                'contact TEXT, '
                'user_type TEXT, '
                'status TEXT, '
                'created_at TEXT)'
        );
      },
    );
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'user_id = ?',
      whereArgs: [user.userId],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'user_id = ?',
      whereArgs: [id],
    );
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'user_id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}




// class User {
//   // Method to create the `users` table
//   void createTable() {
//     // SQL command to create the table
//   }
//
//   // Insert record
//   void insertRecord(Map<String, dynamic> userData) {
//     // SQL command to insert a record
//   }
//
//   // Update record
//   void updateRecord(int id, Map<String, dynamic> userData) {
//     // SQL command to update a record
//   }
//
//   // Delete record
//   void deleteRecord(int id) {
//     // SQL command to delete a record
//   }
//
//   // Get all records
//   List<Map<String, dynamic>> getAllRecords() {
//     // SQL command to fetch all records
//     return [];
//   }
//
//   // Get record by ID
//   Map<String, dynamic>? getById(int id) {
//     // SQL command to fetch a record by ID
//     return null;
//   }
// }
