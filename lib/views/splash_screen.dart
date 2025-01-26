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
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDbInitialized = prefs.getBool('isDbInitialized') ?? false;

      if (!isDbInitialized) {
        // Simulating database creation with progress
        for (int i = 0; i <= 100; i += 20) {
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() {
            _progress = i / 100;
          });
        }

        // Initialize the database
        await _dbHelper.database;

        // Mark database as initialized
        await prefs.setBool('isDbInitialized', true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Database created successfully")),
          );
        }
      }

      // Fetch necessary data
      fetchDataAndStore();

      // Navigate to login page after short delay
      await Future.delayed(const Duration(seconds: 1));
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
            _progress > 0
                ? Column(
              children: [
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  color: Colors.teal,
                ),
                const SizedBox(height: 10),
                Text(
                  "${(_progress * 100).toInt()}% Completed",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal,
                  ),
                ),
              ],
            )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
