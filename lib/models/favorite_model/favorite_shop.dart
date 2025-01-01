class FavoriteShop {
  int? favId;
  int userId;
  int shopId;
  String createdAt;

  FavoriteShop({
    this.favId,
    required this.userId,
    required this.shopId,
    required this.createdAt,
  });

  // Convert a FavoriteShop object into a map (for storing into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'fav_id': favId,
      'user_id': userId,
      'shop_id': shopId,
      'created_at': createdAt,
    };
  }

  // Convert a map into a FavoriteShop object (for reading from SQLite)
  factory FavoriteShop.fromMap(Map<String, dynamic> map) {
    return FavoriteShop(
      favId: map['fav_id'],
      userId: map['user_id'],
      shopId: map['shop_id'],
      createdAt: map['created_at'],
    );
  }
}
