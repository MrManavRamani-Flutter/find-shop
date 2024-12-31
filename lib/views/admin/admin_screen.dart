import 'package:flutter/material.dart';

import '../../data/global_data.dart';

import '../customer/views/customer_profile_screen.dart';
import '../login_screen.dart';
import 'views/admins/admins_screen.dart';
import 'views/customers/customer_screen.dart';
import 'views/products/products_screen.dart';
import 'views/services/services_screen.dart';
import 'views/shops/shop_owners_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  int _getUserCount(String role) {
    return users.where((user) => user['role'] == role).length;
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal.shade800),
              child: const Center(
                child: Text(
                  "Admin Panel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.teal),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.teal),
              title: const Text("Manage Users"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal),
              title: const Text("Logout"),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: globalProducts,
          builder: (context, products, child) {
            return ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: globalServices,
              builder: (context, services, child) {
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to Customers screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerScreen(),
                          ),
                        );
                      },
                      child: _buildDashboardCard(
                        title: "Customers",
                        count: _getUserCount("Customer"),
                        icon: Icons.person,
                        color: Colors.teal.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Shop Owners screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShopOwnersScreen(),
                          ),
                        );
                      },
                      child: _buildDashboardCard(
                        title: "Shop Owners",
                        count: _getUserCount("ShopOwner"),
                        icon: Icons.store,
                        color: Colors.orange.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Admins screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminsScreen(),
                          ),
                        );
                      },
                      child: _buildDashboardCard(
                        title: "Admins",
                        count: _getUserCount("Admin"),
                        icon: Icons.admin_panel_settings,
                        color: Colors.red.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Products screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductsScreen(),
                          ),
                        );
                      },
                      child: _buildDashboardCard(
                        title: "Products",
                        count: products.length,
                        icon: Icons.shopping_bag,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Services screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServicesScreen(),
                          ),
                        );
                      },
                      child: _buildDashboardCard(
                        title: "Services",
                        count: services.length,
                        icon: Icons.design_services,
                        color: Colors.purple.shade600,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ValueListenableBuilder<List<Map<String, dynamic>>>(
      //     valueListenable: globalProducts,
      //     builder: (context, products, child) {
      //       return ValueListenableBuilder<List<Map<String, dynamic>>>(
      //         valueListenable: globalServices,
      //         builder: (context, services, child) {
      //           return GridView.count(
      //             crossAxisCount: 2,
      //             crossAxisSpacing: 16,
      //             mainAxisSpacing: 16,
      //             children: [
      //               _buildDashboardCard(
      //                 title: "Customers",
      //                 count: _getUserCount("Customer"),
      //                 icon: Icons.person,
      //                 color: Colors.teal.shade600,
      //               ),
      //               _buildDashboardCard(
      //                 title: "Shop Owners",
      //                 count: _getUserCount("ShopOwner"),
      //                 icon: Icons.store,
      //                 color: Colors.orange.shade600,
      //               ),
      //               _buildDashboardCard(
      //                 title: "Admins",
      //                 count: _getUserCount("Admin"),
      //                 icon: Icons.admin_panel_settings,
      //                 color: Colors.red.shade600,
      //               ),
      //               _buildDashboardCard(
      //                 title: "Products",
      //                 count: products.length,
      //                 icon: Icons.shopping_bag,
      //                 color: Colors.blue.shade600,
      //               ),
      //               _buildDashboardCard(
      //                 title: "Services",
      //                 count: services.length,
      //                 icon: Icons.design_services,
      //                 color: Colors.purple.shade600,
      //               ),
      //             ],
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            "$count",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
