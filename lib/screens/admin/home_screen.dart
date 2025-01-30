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
      appBar: AppBar(title: const Text('Welcome to Find Shop')),
      drawer: AdminDrawer(userProvider: userProvider),
      body: const AdminDashboardBody(),
    );
  }
}

// Drawer Widget
class AdminDrawer extends StatelessWidget {
  final UserProvider userProvider;

  const AdminDrawer({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AdminDrawerHeader(userProvider: userProvider),
          _buildDrawerItem(context, 'Profile', '/admin_profile'),
          _buildDrawerItem(context, 'Settings', '/settings'),
          const Spacer(),
          _buildLogoutButton(context, userProvider),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }

  Widget _buildLogoutButton(BuildContext context, UserProvider userProvider) {
    return ListTile(
      title: const Text('Logout', style: TextStyle(color: Colors.white)),
      tileColor: Colors.red,
      onTap: () async {
        await SharedPreferencesHelper().clearUserData();
        await SharedPreferencesHelper().clearAuthToken();
        await SharedPreferencesHelper().clearLoginStatus();
        await userProvider.logOut();

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
    );
  }
}

// Drawer Header Widget
class AdminDrawerHeader extends StatelessWidget {
  final UserProvider userProvider;

  const AdminDrawerHeader({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final loggedInUser = userProvider.loggedInUser;
        return InkWell(
          onTap: () {
            if (loggedInUser != null) {
              Navigator.pushReplacementNamed(context, '/admin_profile');
            }
          },
          child: UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            accountName: Text(
              loggedInUser?.username ?? 'Guest',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(loggedInUser?.email ?? 'No email'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/logo/user.png'),
            ),
          ),
        );
      },
    );
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
            icon: Icons.store,
            onTap: () => Navigator.pushNamed(context, '/shop_owners_list'),
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
