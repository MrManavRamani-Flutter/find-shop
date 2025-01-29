import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'customer_details_screen.dart';
import '../../../providers/customer_provider.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer List',
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
      body: Consumer<CustomerProvider>(
        builder: (context, customerProvider, _) {
          final customers = customerProvider.customers;

          if (customerProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (customers.isEmpty) {
            return const Center(child: Text('No customers found.'));
          }

          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ListTile(
                title: Text(customer.username),
                subtitle: Text(customer.email),
                leading: Icon(
                  Icons.person,
                  color: customer.status != 0 ? Colors.green : Colors.red,
                ),
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
              );
            },
          );
        },
      ),
    );
  }
}
