import 'package:find_shop/data/global_data.dart';
import 'package:flutter/material.dart';

class ShopOwnersScreen extends StatelessWidget {
  const ShopOwnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter users with the role 'ShopOwner'
    final shopOwners =
        users.where((user) => user['role'] == 'ShopOwner').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Owners'),
      ),
      body: ListView.builder(
        itemCount: shopOwners.length,
        itemBuilder: (context, index) {
          final shopOwner = shopOwners[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(shopOwner['username']![0].toUpperCase()),
              ),
              title: Text(shopOwner['username']!),
              subtitle: Text('Role: ${shopOwner['role']}'),
              trailing: IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  // Show more details in a dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(shopOwner['username']!),
                        content: Text('Role: ${shopOwner['role']}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
