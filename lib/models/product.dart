class Product {
  final int proId;
  final String proName;
  final String proDesc;
  final double price;
  final int shopId;

  Product({
    required this.proId,
    required this.proName,
    required this.proDesc,
    required this.price,
    required this.shopId,
  });

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
