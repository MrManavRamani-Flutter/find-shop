import 'package:find_shop/models/user.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomersListScreen extends StatelessWidget {
  const CustomersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Fetch users when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.fetchUsers();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Customers List')),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          List<User> customers = userProvider.users
              .where((user) => user.roleId == 1) // Filter customers
              .toList();

          if (customers.isEmpty) {
            return const Center(child: Text("No Customers Found"));
          }

          return RefreshIndicator(
            onRefresh: userProvider.fetchUsers, // Pull to refresh
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return CustomerCard(
                  user: customers[index],
                  onTap: () {
                    // Navigate to customer details
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const CustomerCard({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/logo/user.png'),
        ),
        title: Text(user.username,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(user.email),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.blue),
          onPressed: onTap,
        ),
      ),
    );
  }
}
