import 'package:flutter/material.dart';

class ShopListScreen extends StatelessWidget {
  const ShopListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final shops = [
      {"name": "Tech Hub", "categories": "Electronics, Gadgets"},
      {"name": "Fashion Spot", "categories": "Clothing, Accessories"},
      {"name": "Gourmet Market", "categories": "Food, Beverages"},
      {"name": "Health Haven", "categories": "Medical, Health Products"},
      {"name": "Service Center", "categories": "Repairs, Customizations"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shops",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,

      ),
      body: ListView.builder(
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.store,
                color: Colors.teal.shade700,
                size: 40,
              ),
              title: Text(
                shop['name']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                shop['categories']!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              onTap: () {
                // Add logic for navigating to shop details, if needed
              },
            ),
          );
        },
      ),
    );
  }
}
