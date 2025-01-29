class FavoriteShop {
  final int favId;
  final int userId;
  final int shopId;
  final String addedAt;

  FavoriteShop({
    required this.favId,
    required this.userId,
    required this.shopId,
    required this.addedAt,
  });

  factory FavoriteShop.fromMap(Map<String, dynamic> map) {
    return FavoriteShop(
      favId: map['fav_id'],
      userId: map['user_id'],
      shopId: map['shop_id'],
      addedAt: map['added_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fav_id': favId,
      'user_id': userId,
      'shop_id': shopId,
      'added_at': addedAt,
    };
  }
}
