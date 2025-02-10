class ShopCategory {
  int? shopCatId;
  int shopId;
  int catId;

  ShopCategory({
    this.shopCatId,
    required this.shopId,
    required this.catId,
  });

  // Setters for various fields in the ShopCategory class
  set setShopCatId(int? id) {
    shopCatId = id;
  }

  set setShopId(int id) {
    shopId = id;
  }

  set setCatId(int id) {
    catId = id;
  }

  // Factory constructor to create a ShopCategory object from a map
  factory ShopCategory.fromMap(Map<String, dynamic> map) {
    return ShopCategory(
      shopCatId: map['shop_cat_id'], // Assigning shopCatId from map
      shopId: map['shop_id'], // Assigning shopId from map
      catId: map['cat_id'], // Assigning catId from map
    );
  }

  // Convert ShopCategory object to a map
  Map<String, dynamic> toMap() {
    return {
      'shop_cat_id': shopCatId, // Mapping shopCatId to map
      'shop_id': shopId, // Mapping shopId to map
      'cat_id': catId, // Mapping catId to map
    };
  }
}
