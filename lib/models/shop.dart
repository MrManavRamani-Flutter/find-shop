class Shop {
  int? shopId;
  String? shopName;
  String? address;
  String? mapAddress;
  int? areaId;
  int? userId;
  String? createdAt;

  Shop({
    this.shopId,
    this.shopName,
    this.address,
    this.mapAddress,
    this.areaId,
    this.userId,
    this.createdAt,
  });

  // Setters
  set setShopId(int? id) {
    shopId = id;
  }

  set setShopName(String? name) {
    shopName = name;
  }

  set setAddress(String? addr) {
    address = addr;
  }

  set setMapAddress(String? mapAddr) {
    mapAddress = mapAddr;
  }

  set setAreaId(int? area) {
    areaId = area;
  }

  set setUserId(int? user) {
    userId = user;
  }

  set setCreatedAt(String? created) {
    createdAt = created;
  }

  // CopyWith method
  Shop copyWith({
    int? shopId,
    String? shopName,
    String? address,
    String? mapAddress,
    int? areaId,
    int? userId,
    String? createdAt,
  }) {
    return Shop(
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
      mapAddress: mapAddress ?? this.mapAddress,
      areaId: areaId ?? this.areaId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
