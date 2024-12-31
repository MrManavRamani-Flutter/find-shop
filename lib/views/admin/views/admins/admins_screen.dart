import 'package:find_shop/data/global_data.dart';
import 'package:flutter/material.dart';

class AdminsScreen extends StatelessWidget {
  const AdminsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter users with the role 'Admin'
    final admins = users.where((user) => user['role'] == 'Admin').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admins'),
      ),
      body: ListView.builder(
        itemCount: admins.length,
        itemBuilder: (context, index) {
          final admin = admins[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(admin['username']![0].toUpperCase()),
              ),
              title: Text(admin['username']!),
              subtitle: Text('Role: ${admin['role']}'),
              trailing: IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  // Show more details in a dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(admin['username']!),
                        content: Text('Role: ${admin['role']}'),
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
