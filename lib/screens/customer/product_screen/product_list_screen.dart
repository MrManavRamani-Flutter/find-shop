import 'package:find_shop/database/product_database_helper.dart';
import 'package:find_shop/models/product.dart';
import 'package:find_shop/screens/customer/shops/shop_detail_screen.dart';
import 'package:flutter/material.dart';

class CustomerProductListScreen extends StatefulWidget {
  const CustomerProductListScreen({super.key});

  @override
  CustomerProductListScreenState createState() =>
      CustomerProductListScreenState();
}

class CustomerProductListScreenState extends State<CustomerProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final ProductDatabaseHelper _dbHelper = ProductDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final products = await _dbHelper.getProducts();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  void _searchProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product.proName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<Map<String, dynamic>?> _getUserAndShopByProductId(
      int productId) async {
    final data = await _dbHelper.getUserAndShopByProductId(productId);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/customer_home');
          },
          child: const Icon(Icons.arrow_back),
        ),
        title:
            const Text('Product List', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 10),
            Expanded(child: _buildProductList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search Product...',
        prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: _searchProducts,
    );
  }

  Widget _buildProductList() {
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text(
          'No Product found',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          Product product = _filteredProducts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading:
                  const Icon(Icons.shopping_cart, color: Colors.blueAccent),
              title: Text(
                product.proName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: ElevatedButton(
                onPressed: () async {
                  final productShopUserData =
                      await _getUserAndShopByProductId(product.proId!);
                  if (productShopUserData != null) {
                    final shopId = productShopUserData['shop_id'];
                    final userId = productShopUserData['user_id'];

                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CustomerShopDetailScreen(
                            shopId: shopId,
                            shopUserId: userId,
                          ),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.store_mall_directory_outlined,
                        color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'View Shop',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              subtitle: Text('Price: \$${product.price}'),
              onTap: () => _showProductDetailsDialog(product),
            ),
          );
        },
      ),
    );
  }

  void _showProductDetailsDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.proName,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text('Price: \$${product.price}',
                    style: const TextStyle(fontSize: 18, color: Colors.green)),
                const SizedBox(height: 10),
                Text('Description: ${product.proDesc}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.justify),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
