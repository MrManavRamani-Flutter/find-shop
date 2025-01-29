import 'package:sqflite/sqflite.dart';

class RoleService {
  final Database db;

  RoleService(this.db);

  // Create roles table
  Future<void> createRolesTable() async {
    await db.execute('''
      CREATE TABLE roles (
        role_id INTEGER PRIMARY KEY AUTOINCREMENT,
        role_name TEXT NOT NULL UNIQUE
      )
    ''');
  }

  // Insert default roles
  Future<void> insertDefaultRoles() async {
    const defaultRoles = [
      {'role_name': 'Customer'},
      {'role_name': 'Shop Owner'},
      {'role_name': 'Admin'},
    ];
    for (var role in defaultRoles) {
      await db.insert('roles', role);
    }
  }

  // Fetch all roles
  Future<List<Map<String, dynamic>>> getRoles() async {
    return await db.query('roles');
  }
}
