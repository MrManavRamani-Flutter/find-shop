class FavoriteShop {
  int? favId;
  final int userId;
  final int shopId;
  String? addedAt;

  FavoriteShop({
    this.favId,
    required this.userId,
    required this.shopId,
    this.addedAt,
  });

  // Factory constructor to create a FavoriteShop object from a map
  factory FavoriteShop.fromMap(Map<String, dynamic> map) {
    return FavoriteShop(
      favId: map['fav_id'], // Assigning favId from map
      userId: map['user_id'], // Assigning userId from map
      shopId: map['shop_id'], // Assigning shopId from map
      addedAt: map['added_at'], // Assigning addedAt from map
    );
  }

  // Convert FavoriteShop object to a map
  Map<String, dynamic> toMap() {
    return {
      'fav_id': favId, // Mapping favId to map
      'user_id': userId, // Mapping userId to map
      'shop_id': shopId, // Mapping shopId to map
      'added_at': addedAt, // Mapping addedAt to map
    };
  }
}
