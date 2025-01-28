import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildDashboardTile(
              context: context,
              icon: Icons.supervised_user_circle,
              title: "Manage Users",
              link: '/manage_users',
            ),
            _buildDashboardTile(
              context: context,
              icon: Icons.category,
              title: "Manage Categories",
            ),
            _buildDashboardTile(
              context: context,
              icon: Icons.location_city,
              title: "Manage Areas",
            ),
            _buildDashboardTile(
              context: context,
              icon: Icons.store,
              title: "Manage Shops",
            ),
            // _buildDashboardTile(
            //   context: context,
            //   icon: Icons.shopping_cart,
            //   title: "Manage Products",
            // ),
            // _buildDashboardTile(
            //   context: context,
            //   icon: Icons.favorite,
            //   title: "Favorite Shops",
            // ),
            // _buildDashboardTile(
            //   context: context,
            //   icon: Icons.search,
            //   title: "Search History",
            // ),
            // _buildDashboardTile(
            //   context: context,
            //   icon: Icons.rate_review,
            //   title: "Shop Reviews",
            // ),

          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? link,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          if (link != null) {
            Navigator.pushNamed(context, link);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
