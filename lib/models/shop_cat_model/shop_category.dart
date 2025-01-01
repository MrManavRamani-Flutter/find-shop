class ShopCategory {
  int? shopCatId;
  int shopId;
  int catId;

  ShopCategory({
    this.shopCatId,
    required this.shopId,
    required this.catId,
  });

  // Convert a ShopCategory object into a map (for storing into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'shop_cat_id': shopCatId,
      'shop_id': shopId,
      'cat_id': catId,
    };
  }

  // Convert a map into a ShopCategory object (for reading from SQLite)
  factory ShopCategory.fromMap(Map<String, dynamic> map) {
    return ShopCategory(
      shopCatId: map['shop_cat_id'],
      shopId: map['shop_id'],
      catId: map['cat_id'],
    );
  }
}
