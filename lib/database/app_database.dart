import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'find_shop.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE roles (
      role_id INTEGER PRIMARY KEY AUTOINCREMENT,
      role_name TEXT NOT NULL
    );
    ''');

    // Insert default roles if they do not exist
    final roleCount = await db.query('roles', columns: ['role_id']);
    if (roleCount.isEmpty) {
      // Insert default roles
      await db.insert('roles', {'role_name': 'Customer'});
      await db.insert('roles', {'role_name': 'Shop Owner'});
      await db.insert('roles', {'role_name': 'Admin'});
    }

    await db.execute('''
    CREATE TABLE users (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      contact TEXT,
      role_id INTEGER,
      status INTEGER,
      created_at TEXT,
      FOREIGN KEY (role_id) REFERENCES roles(role_id)
    );
    ''');

    await db.execute('''
    CREATE TABLE areas (
      area_id INTEGER PRIMARY KEY AUTOINCREMENT,
      area_name TEXT NOT NULL
    );
    ''');

    await db.execute('''
    CREATE TABLE categories (
      cat_id INTEGER PRIMARY KEY AUTOINCREMENT,
      cat_name TEXT NOT NULL,
      cat_desc TEXT
    );
    ''');

    await db.execute('''
    CREATE TABLE shops (
      shop_id INTEGER PRIMARY KEY AUTOINCREMENT,
      shop_name TEXT NOT NULL,
      address TEXT,
      map_address TEXT,
      area_id INTEGER,
      user_id INTEGER,
      created_at TEXT,
      FOREIGN KEY (area_id) REFERENCES areas(area_id),
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
    ''');

    await db.execute('''
    CREATE TABLE shop_categories (
      shop_cat_id INTEGER PRIMARY KEY AUTOINCREMENT,
      shop_id INTEGER,
      cat_id INTEGER,
      FOREIGN KEY (shop_id) REFERENCES shops(shop_id),
      FOREIGN KEY (cat_id) REFERENCES categories(cat_id)
    );
    ''');

    await db.execute('''
    CREATE TABLE products (
      pro_id INTEGER PRIMARY KEY AUTOINCREMENT,
      pro_name TEXT NOT NULL,
      pro_desc TEXT,
      price REAL,
      shop_id INTEGER,
      FOREIGN KEY (shop_id) REFERENCES shops(shop_id)
    );
    ''');

    await db.execute('''
    CREATE TABLE favorite_shops (
      fav_id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      shop_id INTEGER,
      added_at TEXT,
      FOREIGN KEY (user_id) REFERENCES users(user_id),
      FOREIGN KEY (shop_id) REFERENCES shops(shop_id)
    );
    ''');

    await db.execute('''
    CREATE TABLE search (
      search_id INTEGER PRIMARY KEY AUTOINCREMENT,
      query TEXT NOT NULL,
      user_id INTEGER,
      searched_at TEXT,
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
    ''');

    await db.execute('''
    CREATE TABLE shop_reviews (
      rev_id INTEGER PRIMARY KEY AUTOINCREMENT,
      comment TEXT,
      rating REAL,
      shop_id INTEGER,
      user_id INTEGER,
      review_date TEXT,
      FOREIGN KEY (shop_id) REFERENCES shops(shop_id),
      FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
    ''');
  }
}
