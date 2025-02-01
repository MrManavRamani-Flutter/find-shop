import 'package:find_shop/screens/admin/home_screen.dart';
import 'package:find_shop/screens/customer/home_screen.dart';
import 'package:find_shop/screens/shop_owner/home_screen.dart';
import 'package:find_shop/screens/shop_owner/shop_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:find_shop/screens/login_screen.dart';
import 'package:find_shop/utils/shared_preferences_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    bool isLoggedIn = await SharedPreferencesHelper().isLoggedIn();
    int? roleId = await SharedPreferencesHelper().getUserRole();

    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn && roleId != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => _getHomeScreen(roleId)),
          );
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    });
  }

  Widget _getHomeScreen(int roleId) {
    if (roleId == 2) {
      return FutureBuilder<int?>(
        future: SharedPreferencesHelper().getUserStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            int? userStatus = snapshot.data;
            return userStatus == 0
                ? const ShopSetupScreen()
                : const ShopOwnerHomeScreen();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      );
    }

    switch (roleId) {
      case 1: // Customer
        return const CustomerHomeScreen();
      case 3: // Admin
        return const AdminHomeScreen();
      default:
        return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Welcome to Find Shop!',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
