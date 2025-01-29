import 'app_database.dart';
import '../models/role.dart';

class RoleDatabaseHelper {
  static const String tableName = 'roles';

  Future<int> insertRole(Role role) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, role.toMap());
  }

  Future<List<Role>> getRoles() async {
    final db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Role.fromMap(maps[i]);
    });
  }

  Future<int> updateRole(Role role) async {
    final db = await AppDatabase().database;
    return await db.update(tableName, role.toMap(), where: 'role_id = ?', whereArgs: [role.roleId]);
  }

  Future<int> deleteRole(int roleId) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'role_id = ?', whereArgs: [roleId]);
  }
}
