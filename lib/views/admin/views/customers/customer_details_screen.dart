import 'package:flutter/material.dart';
import '../../../../data/store_data.dart';
import '../../../../models/user_model/user.dart';
import 'edit_customer_screen.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final User customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.customer.username} Details',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.teal,
                      child: Text(
                        widget.customer.username[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.customer.username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.grey.shade300),
                _buildDetailRow('Username', widget.customer.username),
                _buildDetailRow('Email', widget.customer.email),
                _buildDetailRow('Contact', widget.customer.contact),
                _buildDetailRow('Role', widget.customer.userType),
                _buildDetailRow('Status', widget.customer.status),
                _buildDetailRow('Created At', widget.customer.createdAt),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedCustomer = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditCustomerScreen(customer: widget.customer),
                        ),
                      );

                      if (updatedCustomer != null) {
                        // Handle updated data (e.g., refresh UI)
                        fetchDataAndStore();  // Fetch updated data after edit

                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text(
                      'Edit Customer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
