import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchLoggedInUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Find Shop',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: AdminDrawer(userProvider: userProvider),
      body: const AdminDashboardBody(),
    );
  }
}

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

// Drawer Header Widget
class AdminDrawerHeader extends StatelessWidget {
  final UserProvider userProvider;

  const AdminDrawerHeader({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      final loggedInUser = userProvider.loggedInUser;
      return InkWell(
        onTap: () {
          if (loggedInUser != null) {
            Navigator.pushReplacementNamed(context, '/admin_profile');
          }
        },
        child: UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: Colors.blueAccent),
          accountName: Text(
            loggedInUser?.username ?? 'Guest',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          accountEmail: Text(
            loggedInUser?.email ?? 'No email',
            style: const TextStyle(color: Colors.white70),
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage('assets/logo/user.png'),
          ),
        ),
      );
    });
  }
}

// Admin Dashboard Body Widget
class AdminDashboardBody extends StatelessWidget {
  const AdminDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          AdminDashboardCard(
            title: 'Customers',
            icon: Icons.people,
            onTap: () => Navigator.pushNamed(context, '/customers_list'),
          ),
          AdminDashboardCard(
            title: 'Shop Owners',
            icon: Icons.contact_mail_outlined,
            onTap: () => Navigator.pushNamed(context, '/shop_owners_list'),
          ),
          AdminDashboardCard(
            title: 'Registered Areas',
            icon: Icons.location_on,
            onTap: () => Navigator.pushNamed(context, '/areas_list'),
          ),
          AdminDashboardCard(
            title: 'Shop Category',
            icon: Icons.category,
            onTap: () => Navigator.pushNamed(context, '/categories_list'),
          ),
          AdminDashboardCard(
            title: 'Shop List',
            icon: Icons.storefront_rounded,
            onTap: () => Navigator.pushNamed(context, '/shop_list'),
          ),
          AdminDashboardCard(
            title: 'Product List',
            icon: Icons.shopping_cart,
            onTap: () => Navigator.pushNamed(context, '/product_list'),
          ),
        ],
      ),
    );
  }
}

// Admin Dashboard Card Widget
class AdminDashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const AdminDashboardCard(
      {super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
