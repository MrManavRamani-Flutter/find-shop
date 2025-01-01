class Product {
  int? productId;
  String productName;
  double price;
  String? proDesc;
  String productType;
  int shopId;

  Product({
    this.productId,
    required this.productName,
    required this.price,
    this.proDesc,
    required this.productType,
    required this.shopId,
  });

  // Convert a Product object into a map (for storing into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'pro_desc': proDesc,
      'product_type': productType,
      'shop_id': shopId,
    };
  }

  // Convert a map into a Product object (for reading from SQLite)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['product_id'],
      productName: map['product_name'],
      price: map['price'],
      proDesc: map['pro_desc'],
      productType: map['product_type'],
      shopId: map['shop_id'],
    );
  }
}
