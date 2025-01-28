import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shop_owner_provider.dart';
import 'shop_owner_details_screen.dart';

class ShopOwnerListScreen extends StatelessWidget {
  const ShopOwnerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop Owner List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Consumer<ShopOwnerProvider>(
        builder: (context, shopOwnerProvider, _) {
          final shopOwners = shopOwnerProvider.shopOwners;

          if (shopOwnerProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (shopOwners.isEmpty) {
            return const Center(child: Text('No shop owners found.'));
          }

          return ListView.builder(
            itemCount: shopOwners.length,
            itemBuilder: (context, index) {
              final shopOwner = shopOwners[index];
              return ListTile(
                title: Text(shopOwner.username),
                subtitle: Text(shopOwner.email),
                leading: Icon(
                  Icons.store,
                  color: shopOwner.status != 0 ? Colors.green : Colors.red,
                ),
                onTap: () {
                  // Navigate to the details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShopOwnerDetailsScreen(
                        shopOwner: shopOwner,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
