import 'package:flutter/material.dart';
import '../../../../models/user_model/user.dart';
import '../../../../data/store_data.dart';
import 'customer_details_screen.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter users by role 'Customer'
    final List<User> customers = GlobalData.users
        .where((user) => user.userType.toLowerCase() == 'customer')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: customers.isNotEmpty
            ? ListView.builder(
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
                    customer.username[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  customer.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Role: ${customer.userType}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to the customer details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerDetailsScreen(
                        customer: customer,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        )
            : const Center(
          child: Text(
            'No customers available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
