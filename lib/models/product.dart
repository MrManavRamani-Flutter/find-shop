class Product {
  int? proId;
  String proName;
  String proDesc;
  double price;
  int shopId;

  Product({
    this.proId,
    required this.proName,
    required this.proDesc,
    required this.price,
    required this.shopId,
  });

  // Setter for proId
  set setProId(int id) {
    proId = id;
  }

  // Setter for proName
  set setProName(String name) {
    proName = name;
  }

  // Setter for proDesc
  set setProDesc(String desc) {
    proDesc = desc;
  }

  // Setter for price
  set setPrice(double newPrice) {
    price = newPrice;
  }

  // Setter for shopId
  set setShopId(int id) {
    shopId = id;
  }

  // Factory constructor to create a Product object from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      proId: map['pro_id'],
      // Assigning proId from map
      proName: map['pro_name'],
      // Assigning proName from map
      proDesc: map['pro_desc'],
      // Assigning proDesc from map
      price: map['price'],
      // Assigning price from map
      shopId: map['shop_id'], // Assigning shopId from map
    );
  }

  // Convert Product object to a map
  Map<String, dynamic> toMap() {
    return {
      'pro_id': proId, // Mapping proId to map
      'pro_name': proName, // Mapping proName to map
      'pro_desc': proDesc, // Mapping proDesc to map
      'price': price, // Mapping price to map
      'shop_id': shopId, // Mapping shopId to map
    };
  }
}
