import 'package:find_shop/data/global_data.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
  // Filter users by role 'Customer'
  final List<Map<String, String>> customers =
      users.where((user) => user['role'] == 'Customer').toList();

  CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(
                    customer['username']![0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  customer['username']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('Role: Customer'),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    _showCustomerDetails(context, customer);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Show detailed info about the customer in a dialog
  void _showCustomerDetails(
      BuildContext context, Map<String, String> customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Customer: ${customer['username']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: ${customer['username']}'),
              Text('Role: ${customer['role']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
