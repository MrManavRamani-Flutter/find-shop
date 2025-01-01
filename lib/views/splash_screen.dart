import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:find_shop/views/login_screen.dart';
import 'package:find_shop/database_helper/database_helper.dart';

import '../data/store_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late final DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Get shared preferences instance
      final prefs = await SharedPreferences.getInstance();

      // Check if the database has already been initialized
      final isDbInitialized = prefs.getBool('isDbInitialized') ?? false;

      if (!isDbInitialized) {
        // Initialize the database and insert static data
        await _dbHelper.database;
        await _dbHelper.insertStaticData();

        // Update the shared preference flag
        await prefs.setBool('isDbInitialized', true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Database created successfully")),
          );
        }
      }

      // Fetch data every time the app opens
      fetchDataAndStore();

      // Navigate to the login screen after a delay
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error initializing app: ${e.toString()}")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/find_shop.png',
              height: 180,
              width: 190,
            ),
            const SizedBox(height: 20),
            const Text(
              "Find Shop",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
