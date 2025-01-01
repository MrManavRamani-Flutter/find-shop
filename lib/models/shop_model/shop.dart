class Shop {
  int? shopId;
  String shopName;
  String ownerName;
  String contact;
  String address;
  String? mapAddress;
  int areaId;
  int userId;
  String createdAt;

  Shop({
    this.shopId,
    required this.shopName,
    required this.ownerName,
    required this.contact,
    required this.address,
    this.mapAddress,
    required this.areaId,
    required this.userId,
    required this.createdAt,
  });

  // Convert a Shop object into a map (for storing into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'shop_id': shopId,
      'shop_name': shopName,
      'owner_name': ownerName,
      'contact': contact,
      'address': address,
      'map_address': mapAddress,
      'area_id': areaId,
      'user_id': userId,
      'created_at': createdAt,
    };
  }

  // Convert a map into a Shop object (for reading from SQLite)
  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      shopId: map['shop_id'],
      shopName: map['shop_name'],
      ownerName: map['owner_name'],
      contact: map['contact'],
      address: map['address'],
      mapAddress: map['map_address'],
      areaId: map['area_id'],
      userId: map['user_id'],
      createdAt: map['created_at'],
    );
  }
}
