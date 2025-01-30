import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/screens/shop_owner/update_profile_screen.dart';
import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopOwnerProfileScreen extends StatelessWidget {
  const ShopOwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch logged-in user data
    final userProvider = Provider.of<UserProvider>(context);

    // Fetch the user data (if it's not fetched already)
    if (userProvider.loggedInUser == null) {
      userProvider.fetchLoggedInUser();
    }

    // If user data is still null, show a loading indicator
    if (userProvider.loggedInUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Display the user profile if data is available
    final user = userProvider.loggedInUser;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/shop_home');
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text('Profile',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent, // Blue accent color for app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar with Border and Shadow, aligned to the center
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: const AssetImage('assets/logo/user.png'),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  // Blue border for avatar
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo/user.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // User Details in a Creative Card Design
              Align(
                alignment: Alignment.center,
                child: Card(
                  elevation: 10,
                  // Increased shadow for a creative effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  color: Colors.white,
                  shadowColor: Colors.blueAccent.withOpacity(0.5),
                  // Blue shadow for card
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    // Padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user!.username,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Email:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent.shade700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.email,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Edit Profile Button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the profile update screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileScreen(user: user),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Blue background color
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded button edges
                    ),
                    elevation: 5, // Button shadow
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text color
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Logout Button with Creative Design
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    // Clear SharedPreferences data when logging out
                    SharedPreferencesHelper().clearUserData();
                    SharedPreferencesHelper().clearAuthToken();
                    SharedPreferencesHelper().clearLoginStatus();
        
                    // Log out the user by updating the user provider
                    await userProvider.logOut();
        
                    if (context.mounted) // Redirect to the login screen
                    {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Blue background color
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded button edges
                    ),
                    elevation: 5, // Button shadow
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
