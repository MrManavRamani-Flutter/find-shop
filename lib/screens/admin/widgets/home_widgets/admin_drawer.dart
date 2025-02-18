// widgets/admin_drawer.dart
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

import 'admin_drawer_header.dart';

class AdminDrawer extends StatelessWidget {
  final UserProvider userProvider;

  const AdminDrawer({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AdminDrawerHeader(userProvider: userProvider),
          const Divider(thickness: 1, color: Colors.grey),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                    context, Icons.dashboard, 'Dashboard', '/dashboard'),
                _buildDrawerItem(
                    context, Icons.person, 'Profile', '/admin_profile'),
                _buildDrawerItem(
                    context, Icons.upload_file, 'Upload Data', '/upload_data'),
                _buildDrawerItem(
                    context, Icons.people, 'Customers', '/customers_list'),
                _buildDrawerItem(
                    context, Icons.store, 'Shop Owners', '/shop_owners_list'),
                _buildDrawerItem(context, Icons.location_on, 'Registered Areas',
                    '/areas_list'),
                _buildDrawerItem(context, Icons.category, 'Shop Category',
                    '/categories_list'),
                _buildDrawerItem(
                    context, Icons.shop, 'Shop List', '/shop_list'),
                _buildDrawerItem(
                    context, Icons.list, 'Product List', '/product_list'),
                // _buildDrawerItem(context, Icons.settings, 'Settings', '/settings'),
              ],
            ),
          ),
          _buildLogoutButton(context, userProvider),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }

  Widget _buildLogoutButton(BuildContext context, UserProvider userProvider) {
    return Container(
      width: double.infinity,
      color: Colors.redAccent,
      child: ListTile(
        leading: const Icon(Icons.exit_to_app, color: Colors.white),
        title: const Text('Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onTap: () async {
          await SharedPreferencesHelper().clearUserData();
          await SharedPreferencesHelper().clearAuthToken();
          await SharedPreferencesHelper().clearLoginStatus();
          await userProvider.logOut();

          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
      ),
    );
  }
}
