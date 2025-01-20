import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_model/user.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Factory constructor to return the singleton instance
  factory DatabaseHelper() => _instance;

  // Private internal constructor
  DatabaseHelper._internal();

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'find_shop.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Callback for creating tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        contact TEXT NOT NULL,
        user_type TEXT NOT NULL,
        status TEXT NOT NULL CHECK(status IN ('active', 'inactive')),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
        owner_name TEXT NOT NULL,
        contact TEXT NOT NULL,
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
        product_id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_name TEXT NOT NULL,
        price REAL NOT NULL,
        pro_desc TEXT,
        shop_id INTEGER NOT NULL,
        product_type TEXT NOT NULL CHECK(product_type IN ('service', 'product')),
        FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE favorite_shop (
        fav_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        shop_id INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
        FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE search (
        search_id INTEGER PRIMARY KEY AUTOINCREMENT,
        query TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE shop_reviews (
        review_id INTEGER PRIMARY KEY AUTOINCREMENT,
        rating REAL NOT NULL CHECK(rating BETWEEN 1 AND 5),
        review TEXT,
        shop_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
      );
    ''');
  }

  // Insert static data
  Future<void> insertStaticData() async {
    final db = await database;

    // Insert data into 'users' table
    await db.insert('users', {
      'username': 'Ishvarbhai Ramani',
      'email': 'palav13@gmail.com',
      'password': '123',
      'contact': '1234567890',
      'user_type': 'ShopOwner',
      'status': 'active'
    });

    // Insert data into 'users' table
    await db.insert('users', {
      'username': 'Jaswantbhai',
      'email': 'Jaswantbhai12@gmail.com',
      'password': '123',
      'contact': '1234567890',
      'user_type': 'ShopOwner',
      'status': 'active'
    });
    // Insert data into 'users' table
    await db.insert('users', {
      'username': 'Jay Sosa',
      'email': 'jay4455@gmail.com',
      'password': '123',
      'contact': '1234567890',
      'user_type': 'Customer',
      'status': 'active'
    });

    // Insert data into 'users' table
    await db.insert('users', {
      'username': 'Raj Ramani',
      'email': 'raj999@gmail.com',
      'password': '123',
      'contact': '1234567890',
      'user_type': 'Customer',
      'status': 'inactive'
    });

    // Insert data into 'users' table
    await db.insert('users', {
      'username': 'Manav Ramani',
      'email': 'manav134@gmail.com',
      'password': '123',
      'contact': '1234567890',
      'user_type': 'Admin',
      'status': 'active'
    });
    // Insert data into 'users' table
    await db.insert('users', {
      'username': 'admin',
      'email': 'admin@gmail.com',
      'password': '123',
      'contact': '1234567890',
      'user_type': 'Admin',
      'status': 'inactive'
    });

    // Insert data into 'areas' table
    await db.insert('areas', {
      'area_name': 'Main Bazaar',
      'city': 'Jasdan',
      'state': 'Gujarat',
      'pincode': '360050'
    });
    // Insert data into 'areas' table
    await db.insert('areas', {
      'area_name': 'Chitaliya Road',
      'city': 'Jasdan',
      'state': 'Gujarat',
      'pincode': '360050'
    });
    // Insert data into 'areas' table
    await db.insert('areas', {
      'area_name': 'Moti Chock',
      'city': 'Jasdan',
      'state': 'Gujarat',
      'pincode': '360050'
    });

    // Insert data into 'categories' table
    await db.insert('categories', {
      'cat_name': 'Cloth kapad',
      'cat_desc': 'dress kapad, ashtar, chaniya'
    });

    // Insert data into 'categories' table
    await db.insert('categories', {
      'cat_name': 'cloth',
      'cat_desc': 'man shirt, t-shirt, dress, kid cloth'
    });
    // Insert data into 'categories' table
    await db.insert('categories',
        {'cat_name': 'electric', 'cat_desc': 'TV, CCTV, Camera,'});

    // Insert data into 'shops' table
    await db.insert('shops', {
      'shop_name': 'Palav Matching',
      'owner_name': 'Ishvarbhai Ramani',
      'contact': '7096584269',
      'address': 'Bhagyodai 10, main bazaar, jasdan',
      'map_address': 'https://maps.app.goo.gl/3J3raXH7zN4CoMgn7',
      'user_id': 1,
      'area_id': 1
    });

    // Insert data into 'shops' table
    await db.insert('shops', {
      'shop_name': 'Dharti Computer',
      'owner_name': 'Jaswantbhai',
      'contact': '7096584269',
      'address': 'Chitaliya Road, jasdan',
      'map_address': 'https://maps.app.goo.gl/8h4uosAN1os38FpS6',
      'user_id': 2,
      'area_id': 1
    });

    // Insert data into 'shop_categories' table
    await db.insert('shop_categories', {
      'shop_id': 1, // Assuming shop_id is 1 for Tech Store
      'cat_id': 1 // Assuming cat_id is 1 for Electronics
    });

    // Insert data into 'shop_categories' table
    await db.insert('shop_categories', {
      'shop_id': 2, // Assuming shop_id is 1 for Tech Store
      'cat_id': 3 // Assuming cat_id is 1 for Electronics
    });

// Insert data into 'products' table
    await db.insert('products', {
      'product_name': 'Ashtar',
      'price': 40.00,
      'pro_desc': '35 pano, high quality material',
      'shop_id': 1,
      'product_type': 'product', // Specify the product type
    });

// Insert data into 'products' table
    await db.insert('products', {
      'product_name': 'Lenovo',
      'price': 25000.00,
      'pro_desc': '8GB RAM, Win 11, 256GB HHD, 2GB Graphics Card',
      'shop_id': 2,
      'product_type': 'product', // Specify the product type
    });

    await db.insert('products', {
      'product_name': 'Repair Service',
      'price': 200.00,
      'pro_desc': 'Fixing electronic devices',
      'shop_id': 2,
      'product_type': 'service',
    });

    // Insert data into 'favorite_shop' table
    await db.insert('favorite_shop', {
      'user_id': 3, // Assuming user_id is 1 for John Doe
      'shop_id': 1 // Assuming shop_id is 1 for Tech Store
    });

    // Insert data into 'favorite_shop' table
    await db.insert('favorite_shop', {
      'user_id': 4, // Assuming user_id is 1 for John Doe
      'shop_id': 2 // Assuming shop_id is 1 for Tech Store
    });

    // Insert data into 'favorite_shop' table
    await db.insert('favorite_shop', {
      'user_id': 3, // Assuming user_id is 1 for John Doe
      'shop_id': 2 // Assuming shop_id is 1 for Tech Store
    });

    // Insert data into 'favorite_shop' table
    await db.insert('favorite_shop', {
      'user_id': 5, // Assuming user_id is 1 for John Doe
      'shop_id': 1 // Assuming shop_id is 1 for Tech Store
    });

    // Insert data into 'search' table
    await db.insert('search', {
      'query': 'Cloth',
      'user_id': 3, // Assuming user_id is 1 for John Doe
    });

    // Insert data into 'search' table
    await db.insert('search', {
      'query': 'Lenovo',
      'user_id': 3, // Assuming user_id is 1 for John Doe
    });

    // Insert data into 'search' table
    await db.insert('search', {
      'query': 'TV',
      'user_id': 4, // Assuming user_id is 1 for John Doe
    });

    // Insert data into 'search' table
    await db.insert('search', {
      'query': 'ashtar',
      'user_id': 5, // Assuming user_id is 1 for John Doe
    });

    // Insert data into 'shop_reviews' table
    await db.insert('shop_reviews', {
      'rating': 5,
      'review': 'Great store with excellent products!',
      'shop_id': 1, // Assuming shop_id is 1 for Tech Store
      'user_id': 3, // Assuming user_id is 1 for John Doe
    });

    // Insert data into 'shop_reviews' table
    await db.insert('shop_reviews', {
      'rating': 4,
      'review': 'Great store with excellent products!',
      'shop_id': 2, // Assuming shop_id is 1 for Tech Store
      'user_id': 5, // Assuming user_id is 1 for John Doe
    });

    // Insert data into 'shop_reviews' table
    await db.insert('shop_reviews', {
      'rating': 4.5,
      'review': 'Great store with excellent products!',
      'shop_id': 1, // Assuming shop_id is 1 for Tech Store
      'user_id': 5, // Assuming user_id is 1 for John Doe
    });

    print('Static data inserted successfully!');
  }

  // Update customer details
  Future<void> updateCustomer(User customer) async {
    final db = await database;
    await db.update(
      'users',
      {
        'username': customer.username,
        'email': customer.email,
        'contact': customer.contact,
      },
      where: 'user_id = ?',
      whereArgs: [customer.userId],
    );
  }

  // Fetch customers from the database
  Future<List<User>> fetchCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User(
        userId: maps[i]['user_id'],
        username: maps[i]['username'],
        email: maps[i]['email'],
        contact: maps[i]['contact'],
        userType: maps[i]['user_type'],
        status: maps[i]['status'],
        password: maps[i]['password'],
        createdAt: maps[i]['createdAt'],
      );
    });
  }

  // Close the database
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
