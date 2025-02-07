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

  // Setters
  set setProId(int id) {
    proId = id;
  }

  set setProName(String name) {
    proName = name;
  }

  set setProDesc(String desc) {
    proDesc = desc;
  }

  set setPrice(double newPrice) {
    price = newPrice;
  }

  set setShopId(int id) {
    shopId = id;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      proId: map['pro_id'],
      proName: map['pro_name'],
      proDesc: map['pro_desc'],
      price: map['price'],
      shopId: map['shop_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pro_id': proId,
      'pro_name': proName,
      'pro_desc': proDesc,
      'price': price,
      'shop_id': shopId,
    };
  }
}
