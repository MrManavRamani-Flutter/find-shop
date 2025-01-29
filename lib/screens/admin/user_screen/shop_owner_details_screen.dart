import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../providers/shop_owner_provider.dart';

class ShopOwnerDetailsScreen extends StatelessWidget {
  final UserModel shopOwner;

  const ShopOwnerDetailsScreen({super.key, required this.shopOwner});

  @override
  Widget build(BuildContext context) {
    final shopOwnerProvider =
        Provider.of<ShopOwnerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop Owner Details',
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
        builder: (context, provider, child) {
          final updatedShopOwner = provider.getShopOwnerById(shopOwner.userId!);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.store,
                            size: 40, color: Colors.blueAccent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              updatedShopOwner!.username,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              updatedShopOwner.email,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Status Section with Toggle Button
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              updatedShopOwner.status != 0
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: updatedShopOwner.status != 0
                                  ? Colors.green
                                  : Colors.red,
                              size: 30,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              updatedShopOwner.status != 0
                                  ? "Active"
                                  : "Inactive",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: updatedShopOwner.status != 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final newStatus =
                                updatedShopOwner.status == 0 ? 1 : 0;

                            // Update the status using provider
                            await shopOwnerProvider.updateShopOwnerStatus(
                              updatedShopOwner.userId!,
                              newStatus,
                            );

                            // Re-fetch the updated shop owner data
                            await shopOwnerProvider.fetchShopOwners();
                            if (context.mounted) {
                              // Show a confirmation message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    newStatus == 1
                                        ? 'Shop Owner Activated'
                                        : 'Shop Owner Deactivated',
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: updatedShopOwner.status != 0
                                ? Colors.red
                                : Colors.green,
                          ),
                          child: Text(
                            updatedShopOwner.status != 0
                                ? "Deactivate"
                                : "Activate",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Details Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Contact Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.blueAccent),
                            const SizedBox(width: 16),
                            Text(
                              updatedShopOwner.contact,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.blueAccent),
                            const SizedBox(width: 16),
                            Text(
                              updatedShopOwner.email,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
