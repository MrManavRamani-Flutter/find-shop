import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/models/user.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'customer_detail_screen.dart';

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({super.key});

  @override
  CustomersListScreenState createState() => CustomersListScreenState();
}

class CustomersListScreenState extends State<CustomersListScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch users when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: UserSearchDelegate(userProvider));
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Filter customers based on search query and roleId == 1 (Customers)
          List<User> customers = userProvider.users
              .where((user) =>
          user.roleId == 1 && // Ensure the user is a customer
              (user.username.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  user.email.toLowerCase().contains(searchQuery.toLowerCase())))
              .toList();

          if (customers.isEmpty) {
            return const Center(child: Text("No Customers Found"));
          }

          return RefreshIndicator(
            onRefresh: userProvider.fetchUsers,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return CustomerCard(
                  user: customers[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerDetailScreen(
                          user: customers[index],
                        ),
                      ),
                    );
                  },
                  onStatusChange: () {
                    // Show dialog box first for confirmation
                    _showStatusChangeDialog(context, customers[index], userProvider);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showStatusChangeDialog(BuildContext context, User user, UserProvider userProvider) {
    // Show confirmation dialog before changing the status
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(user.status == 1 ? 'Block User' : 'Activate User'),
          content: Text(
            user.status == 1
                ? 'Are you sure you want to block this customer?'
                : 'Are you sure you want to activate this customer?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog without making changes
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Change the status and close the dialog
                int newStatus = user.status == 1 ? 2 : 1;
                userProvider.updateUserStatus(user.userId, newStatus);

                // Close the dialog after processing the status change
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

class CustomerCard extends StatelessWidget {
  final User user;
  final VoidCallback onTap;
  final VoidCallback onStatusChange;

  const CustomerCard({super.key, required this.user, required this.onTap, required this.onStatusChange});

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
          icon: Icon(
            user.status == 1 ? Icons.lock_open : Icons.lock,
            color: user.status == 1 ? Colors.green : Colors.red,
          ),
          onPressed: onStatusChange,
        ),
        onTap: onTap,
      ),
    );
  }
}

class UserSearchDelegate extends SearchDelegate {
  final UserProvider userProvider;

  UserSearchDelegate(this.userProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredUsers = userProvider.users
        .where((user) => user.roleId == 1 && // Filter by customer role
        (user.username.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase())))
        .toList();

    if (filteredUsers.isEmpty) {
      return const Center(child: Text("No results found"));
    }

    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return ListTile(
          title: Text(user.username),
          subtitle: Text(user.email),
          onTap: () {
            // Navigate to user details
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDetailScreen(user: user),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
