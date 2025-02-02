import 'package:find_shop/screens/admin/shop_owner/shop_owner_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/models/user.dart';
import 'package:find_shop/providers/user_provider.dart';

class ShopOwnerListScreen extends StatelessWidget {
  const ShopOwnerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/dashboard');
              },
              child: const Icon(Icons.arrow_back)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blueAccent,
          title: const Text('Shop Owners',style: TextStyle(color: Colors.white),),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Approved"),
              Tab(text: "Rejected"),
              Tab(text: "Others"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ShopOwnerList(status: 3), // Pending
            ShopOwnerList(status: 1), // Approved
            ShopOwnerList(status: 2), // Rejected
            ShopOwnerList(status: 0), // Others
          ],
        ),
      ),
    );
  }
}

class ShopOwnerList extends StatelessWidget {
  final int status;

  const ShopOwnerList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        userProvider.fetchUsers(); // Fetch latest data

        List<User> shopOwners = userProvider.users
            .where((user) => user.roleId == 2 && user.status == status)
            .toList();

        if (shopOwners.isEmpty) {
          return const Center(
            child: Text(
              "No Shop Owners Found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: shopOwners.length,
          itemBuilder: (context, index) {
            return ShopOwnerCard(owner: shopOwners[index]);
          },
        );
      },
    );
  }
}

class ShopOwnerCard extends StatelessWidget {
  final User owner;

  const ShopOwnerCard({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(owner.status).withOpacity(0.2),
          child: Icon(
            Icons.storefront,
            color: _getStatusColor(owner.status),
          ),
        ),
        title: Text(
          owner.username,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(owner.email),
        trailing: Text(
          owner.contact,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        onTap: () {
          if (owner.status == 3) {
            // Navigate only for pending users
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopOwnerDetailScreen(owner: owner),
              ),
            );
          }
        },
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 3:
        return Colors.orange; // Pending
      case 1:
        return Colors.green; // Approved
      case 2:
        return Colors.red; // Rejected
      case 0:
        return Colors.blueGrey; // Others
      default:
        return Colors.grey;
    }
  }
}
