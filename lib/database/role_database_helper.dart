import 'app_database.dart';
import '../models/role.dart';

class RoleDatabaseHelper {
  static const String tableName = 'roles';

  // Insert a new role into the database
  Future<int> insertRole(Role role) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, role.toMap());
  }

  // Fetch all roles from the database
  Future<List<Role>> getRoles() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Role.fromMap(maps[i]);
    });
  }

  // Update an existing role by its ID
  Future<int> updateRole(Role role) async {
    final db = await AppDatabase().database;
    return await db.update(
      tableName,
      role.toMap(),
      where: 'role_id = ?',
      whereArgs: [role.roleId],
    );
  }

  // Delete a role by its ID
  Future<int> deleteRole(int roleId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'role_id = ?', whereArgs: [roleId]);
  }
}
