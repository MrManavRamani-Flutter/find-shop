import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables/area_service.dart';
import 'tables/role_service.dart';
import 'tables/user_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;
  bool _isDatabaseCreated = false;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'find_shop.db');

    try {
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      rethrow; // If any error occurs during DB creation, rethrow it.
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    final roleService = RoleService(db);
    final userService = UserService(db);
    final areaService = AreaService(db);

    await roleService.createRolesTable();
    await userService.createUsersTable();
    await areaService.createAreasTable();
    await roleService.insertDefaultRoles();

    // Mark database as created
    _isDatabaseCreated = true;
  }

  bool get isDatabaseCreated => _isDatabaseCreated;

  RoleService getRoleService() {
    return RoleService(_database!);
  }

  UserService getUserService() {
    return UserService(_database!);
  }

  AreaService getAreaService() {
    return AreaService(_database!);
  }
}
