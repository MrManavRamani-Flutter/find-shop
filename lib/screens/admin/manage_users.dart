import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shop_owner_provider.dart';
import 'shop_owner_list_screen.dart'; // Import the Shop Owner List Screen

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  ManageUsersState createState() => ManageUsersState();
}

class ManageUsersState extends State<ManageUsers> {
  @override
  void initState() {
    super.initState();

    // Fetch shop owners on screen load
    Future.delayed(Duration.zero, () {
      if (mounted) {
        Provider.of<ShopOwnerProvider>(context, listen: false)
            .fetchShopOwners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopOwnerProvider = Provider.of<ShopOwnerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Users',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildUserCountSection(shopOwnerProvider: shopOwnerProvider),
        ),
      ),
    );
  }

  Widget _buildUserCountSection(
      {required ShopOwnerProvider shopOwnerProvider}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildCountTile(
            title: "Customers",
            count: 0,
            // Placeholder, replace with actual customer count if available
            icon: Icons.person,
            onTap: () {
              // Navigate to the Customer List Screen
              // Replace with your actual customer list screen
            },
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildCountTile(
            title: "Shop Owners",
            count: shopOwnerProvider.shopOwners.length,
            icon: Icons.store,
            onTap: () {
              // Navigate to the Shop Owner List Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShopOwnerListScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCountTile({
    required String title,
    required int count,
    required IconData icon,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                radius: 30,
                child: Icon(icon, size: 40, color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
