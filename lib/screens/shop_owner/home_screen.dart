import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopOwnerHomeScreen extends StatelessWidget {
  const ShopOwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch logged-in user data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchLoggedInUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Find Shop'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            // Drawer header
            _buildDrawerHeader(context),

            // Other drawer options
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile screen
                Navigator.pushReplacementNamed(context, '/shop_profile');
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings screen
                // Navigator.pushNamed(context, '/settings');
              },
            ),

            // Spacer to push logout button to the bottom
            const Spacer(),

            // Logout button at the bottom
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              tileColor: Colors.red, // Red background color
              onTap: () async {
                // Clear SharedPreferences data when logging out
                SharedPreferencesHelper().clearUserData();
                SharedPreferencesHelper().clearAuthToken();
                SharedPreferencesHelper().clearLoginStatus();

                // Log out the user by updating the user provider
                await userProvider.logOut();
                if (context.mounted) {
                  // Redirect to the login screen
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Welcome to Our Shop',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the Drawer Header with Avatar and User Info
  Widget _buildDrawerHeader(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final loggedInUser = userProvider.loggedInUser;

        return InkWell(
          onTap: () {
            if (loggedInUser != null) {
              Navigator.pushReplacementNamed(context, '/shop_profile');
            }
          },
          child: UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text(
              loggedInUser?.username ?? 'Guest',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              loggedInUser?.email ?? 'No email',
            ),
            currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/logo/user.png')),
          ),
        );
      },
    );
  }
}
