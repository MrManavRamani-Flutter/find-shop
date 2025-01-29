class Shop {
  final int shopId;
  final String shopName;
  final String address;
  final String mapAddress;
  final int areaId;
  final int userId;
  final String createdAt;

  Shop({
    required this.shopId,
    required this.shopName,
    required this.address,
    required this.mapAddress,
    required this.areaId,
    required this.userId,
    required this.createdAt,
  });

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      shopId: map['shop_id'],
      shopName: map['shop_name'],
      address: map['address'],
      mapAddress: map['map_address'],
      areaId: map['area_id'],
      userId: map['user_id'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shop_id': shopId,
      'shop_name': shopName,
      'address': address,
      'map_address': mapAddress,
      'area_id': areaId,
      'user_id': userId,
      'created_at': createdAt,
    };
  }
}
