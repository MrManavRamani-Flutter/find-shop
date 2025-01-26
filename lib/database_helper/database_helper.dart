import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'insert_demo_data/insert_data.dart';

class DatabaseHelper {
  // Singleton instance
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
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'find_shop.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE roles (
          role_id INTEGER PRIMARY KEY AUTOINCREMENT,
          role_name TEXT NOT NULL
        );
      ''');

      await db.execute('''
        CREATE TABLE users (
          user_id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          contact TEXT NOT NULL,
          role_id INTEGER NOT NULL,
          status TEXT NOT NULL CHECK(status IN ('active', 'inactive')),
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
        );
      ''');

      await db.execute('''
        CREATE TABLE areas (
          area_id INTEGER PRIMARY KEY AUTOINCREMENT,
          area_name TEXT NOT NULL,
          city TEXT NOT NULL,
          state TEXT NOT NULL,
          pincode TEXT NOT NULL
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
          address TEXT NOT NULL,
          map_address TEXT,
          area_id INTEGER NOT NULL,
          user_id INTEGER NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (area_id) REFERENCES areas(area_id) ON DELETE CASCADE,
          FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
        );
      ''');

      await db.execute('''
        CREATE TABLE shop_categories (
          shop_cat_id INTEGER PRIMARY KEY AUTOINCREMENT,
          shop_id INTEGER NOT NULL,
          cat_id INTEGER NOT NULL,
          FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE CASCADE,
          FOREIGN KEY (cat_id) REFERENCES categories(cat_id) ON DELETE CASCADE
        );
      ''');

      await db.execute('''
        CREATE TABLE products (
          pro_id INTEGER PRIMARY KEY AUTOINCREMENT,
          pro_name TEXT NOT NULL,
          pro_decs TEXT,
          price REAL NOT NULL,
          shop_id INTEGER NOT NULL,
          FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE CASCADE
        );
      ''');

      await db.execute('''
        CREATE TABLE favorite_shop (
          fav_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          shop_id INTEGER NOT NULL,
          added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
          FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE CASCADE
        );
      ''');

      await db.execute('''
        CREATE TABLE search (
          search_id INTEGER PRIMARY KEY AUTOINCREMENT,
          query TEXT NOT NULL,
          user_id INTEGER NOT NULL,
          searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
        );
      ''');

      await db.execute('''
        CREATE TABLE shop_reviews (
          rev_id INTEGER PRIMARY KEY AUTOINCREMENT,
          comment TEXT,
          rating REAL NOT NULL CHECK(rating BETWEEN 1 AND 5),
          shop_id INTEGER NOT NULL,
          user_id INTEGER NOT NULL,
          review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE CASCADE,
          FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
        );
      ''');

      // Insert initial data
      await InsertRoles.insert(db);
      await InsertUsers.insert(db);
      await InsertAreas.insert(db);
      await InsertCategories.insert(db);
      await InsertShops.insert(db);
      await InsertShopCategories.insert(db);
      await InsertProducts.insert(db);
      await InsertFavoriteShops.insert(db);
      await InsertSearch.insert(db);
      await InsertShopReviews.insert(db);

      print('Database initialized successfully');

      print('Database tables created successfully');
    } catch (e) {
      print('Error creating tables: $e');
      rethrow;
    }
  }
}
