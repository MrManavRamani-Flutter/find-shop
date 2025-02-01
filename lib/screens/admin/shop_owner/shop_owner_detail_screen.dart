import 'package:find_shop/models/user.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopOwnerDetailScreen extends StatelessWidget {
  final User owner;

  const ShopOwnerDetailScreen({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    // Get UserProvider instance
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: Text(owner.username)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Shop Logo (representative)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orangeAccent.withOpacity(0.3),
                child: const Icon(
                  Icons.storefront,
                  size: 70,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Shop Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Shop Name", owner.username),
                    // Assuming shop name is same as username for now
                    _buildDetailRow("Owner Name", owner.username),
                    _buildDetailRow("Email", owner.email),
                    _buildDetailRow("Contact", owner.contact),
                    _buildDetailRow("Status", _getStatusText(owner.status)),
                    const SizedBox(height: 20),

                    // Approve or Reject buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _updateUserStatus(
                                context, userProvider, 1); // Approved
                          },
                          child: const Text("Approve"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            _updateUserStatus(
                                context, userProvider, 2); // Rejected
                          },
                          child: const Text("Reject"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Update Map Address Option (if needed)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // You can implement update map address functionality here if needed
                        },
                        child: const Text("Update Map Address"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 3:
        return "Pending";
      case 1:
        return "Approved";
      case 2:
        return "Rejected";
      case 0:
        return "Others";
      default:
        return "Unknown";
    }
  }

  // Method to update user status (Approve or Reject)
  void _updateUserStatus(
      BuildContext context, UserProvider userProvider, int newStatus) async {
    final updatedOwner =
        owner.copyWith(status: newStatus); // Create a copy with updated status

    await userProvider
        .updateUser(updatedOwner); // Update user status in the database

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newStatus == 1 ? 'User approved!' : 'User rejected!',
        ),
      ),
    );
  }
}
