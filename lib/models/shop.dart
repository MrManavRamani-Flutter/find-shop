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

  // Setters for various fields in the Shop class
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

  // CopyWith method allows creating a new instance with some fields changed
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

  // Factory constructor to create a Shop object from a map
  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      shopId: map['shop_id'], // Assigning shopId from map
      shopName: map['shop_name'], // Assigning shopName from map
      address: map['address'], // Assigning address from map
      mapAddress: map['map_address'], // Assigning mapAddress from map
      areaId: map['area_id'], // Assigning areaId from map
      userId: map['user_id'], // Assigning userId from map
      createdAt: map['created_at'], // Assigning createdAt from map
    );
  }

  // Convert Shop object to a map
  Map<String, dynamic> toMap() {
    return {
      'shop_id': shopId, // Mapping shopId to map
      'shop_name': shopName, // Mapping shopName to map
      'address': address, // Mapping address to map
      'map_address': mapAddress, // Mapping mapAddress to map
      'area_id': areaId, // Mapping areaId to map
      'user_id': userId, // Mapping userId to map
      'created_at': createdAt, // Mapping createdAt to map
    };
  }
}
