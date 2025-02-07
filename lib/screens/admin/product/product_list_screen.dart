import 'package:find_shop/models/product.dart';
import 'package:find_shop/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminProductListScreen extends StatefulWidget {
  const AdminProductListScreen({super.key});

  @override
  _AdminProductListScreenState createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetch products when the screen is loaded
    Future.delayed(Duration.zero, () {
      if (context.mounted) {
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar in the body
            _buildSearchBar(),
            const SizedBox(height: 10),
            // Product list
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                // If the products list is empty or loading, show a loading indicator
                if (productProvider.products.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // List all products
                return Expanded(
                  child: ListView.builder(
                    itemCount: productProvider.filteredProducts.length,
                    itemBuilder: (context, index) {
                      Product product = productProvider.filteredProducts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(
                            Icons.shopping_cart,
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            product.proName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Price: ${product.price}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green),
                          ),
                          onTap: () {
                            // Show product details in a dialog when tapped
                            _showProductDetailsDialog(context, product);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Search bar widget
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search Product...',
        prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  // Trigger the search logic when clearing
                  Provider.of<ProductProvider>(context, listen: false)
                      .fetchProducts();
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (query) {
        // Trigger search logic when text changes
        Provider.of<ProductProvider>(context, listen: false)
            .searchProducts(query);
      },
    );
  }

  // Function to show the product details in a dialog
  void _showProductDetailsDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product name with large text and bold style
                Text(
                  product.proName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Product price
                Text(
                  'Price: ${product.price}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                // Product description with padding
                Text(
                  'Description: ${product.proDesc}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                // Close button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
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
