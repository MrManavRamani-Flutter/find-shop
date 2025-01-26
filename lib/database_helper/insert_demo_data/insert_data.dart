import 'package:sqflite/sqflite.dart';

// Insert roles data
class InsertRoles {
  static Future<void> insert(Database db) async {
    await db.insert('roles', {'role_name': 'Admin'});
    await db.insert('roles', {'role_name': 'Shop Owner'});
    await db.insert('roles', {'role_name': 'Customer'});
    print('Roles data inserted successfully');
  }
}

// Insert users data
class InsertUsers {
  static Future<void> insert(Database db) async {
    await db.insert('users', {
      'username': 'admin',
      'email': 'admin@example.com',
      'password': '123456',
      'contact': '9876543210',
      'role_id': 1,
      'status': 'active',
    });
    print('Users data inserted successfully');
  }
}

// Insert areas data
class InsertAreas {
  static Future<void> insert(Database db) async {
    await db.insert('areas', {
      'area_name': 'Jasdan',
      'city': 'Rajkot',
      'state': 'Gujarat',
      'pincode': '360050',
    });
    print('Areas data inserted successfully');
  }
}

// Insert categories data
class InsertCategories {
  static Future<void> insert(Database db) async {
    await db.insert('categories', {'cat_name': 'Clothing', 'cat_desc': 'Men and Women Clothing'});
    await db.insert('categories', {'cat_name': 'Accessories', 'cat_desc': 'Fashion Accessories'});
    print('Categories data inserted successfully');
  }
}

// Insert shops data
class InsertShops {
  static Future<void> insert(Database db) async {
    await db.insert('shops', {
      'shop_name': 'Palav Matching',
      'address': 'Main Bazaar, Jasdan',
      'map_address': '22.0374,71.2078',
      'area_id': 1,
      'user_id': 1,
    });
    print('Shops data inserted successfully');
  }
}

// Insert shop categories data
class InsertShopCategories {
  static Future<void> insert(Database db) async {
    await db.insert('shop_categories', {'shop_id': 1, 'cat_id': 1});
    print('Shop categories data inserted successfully');
  }
}

// Insert products data
class InsertProducts {
  static Future<void> insert(Database db) async {
    await db.insert('products', {
      'pro_name': 'Traditional Saree',
      'pro_desc': 'Beautiful traditional saree',
      'price': 2500.00,
      'shop_id': 1,
    });
    print('Products data inserted successfully');
  }
}

// Insert favorite shops data
class InsertFavoriteShops {
  static Future<void> insert(Database db) async {
    await db.insert('favorite_shop', {
      'user_id': 1,
      'shop_id': 1,
      'added_at': DateTime.now().toIso8601String(),
    });
    print('Favorite shops data inserted successfully');
  }
}

// Insert search data
class InsertSearch {
  static Future<void> insert(Database db) async {
    await db.insert('search', {
      'query': 'Traditional Saree',
      'user_id': 1,
      'searched_at': DateTime.now().toIso8601String(),
    });
    print('Search data inserted successfully');
  }
}

// Insert shop reviews data
class InsertShopReviews {
  static Future<void> insert(Database db) async {
    await db.insert('shop_reviews', {
      'comment': 'Amazing collection!',
      'rating': 5,
      'shop_id': 1,
      'user_id': 1,
      'review_date': DateTime.now().toIso8601String(),
    });
    print('Shop reviews data inserted successfully');
  }
}
