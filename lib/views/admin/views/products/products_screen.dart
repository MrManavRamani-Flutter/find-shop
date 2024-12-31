import 'package:find_shop/data/global_data.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: globalProducts,
        builder: (context, products, child) {
          if (products.isEmpty) {
            return const Center(
              child: Text('No products available'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        product['available'] ? Colors.green : Colors.red,
                    child: Icon(
                      product['available'] ? Icons.check : Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(product['name']),
                  subtitle: Text(
                    'Category: ${product['category']}\n'
                    'Price: Rs. ${product['price']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ProductDetailsDialog(product: product),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsDialog({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(product['name']),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category: ${product['category']}'),
          Text('Price: Rs. ${product['price']}'),
          Text('Available: ${product['available'] ? "Yes" : "No"}'),
          if (product.containsKey('shopName'))
            Text('Shop Name: ${product['shopName']}'),
          if (product.containsKey('address'))
            Text('Address: ${product['address']}'),
          if (product.containsKey('contact'))
            Text('Contact: ${product['contact']}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
