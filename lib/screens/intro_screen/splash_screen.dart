import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:find_shop/services/database_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late final DatabaseService _dbService;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _dbService = DatabaseService();
    _initializeApp();
  }

  // Initialize the app, including database setup and fetching user roles
  Future<void> _initializeApp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDbInitialized = prefs.getBool('isDbInitialized') ?? false;

      if (!isDbInitialized) {
        for (int i = 0; i <= 100; i += 20) {
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() {
            _progress = i / 100;
          });
        }

        await _dbService.database;
        await _checkAndInsertRoles();
        await prefs.setBool('isDbInitialized', true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Database created and roles inserted successfully!'),
            ),
          );
        }
      }

      // Fetch roles and store them in SharedPreferences
      await _fetchAndStoreRoles();

      // Wait before navigating to the login screen
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing app: $e')),
      );
    }
  }

  // Insert default roles if the roles table is empty
  Future<void> _checkAndInsertRoles() async {
    final db = await _dbService.database;
    final roleService = _dbService.getRoleService();

    final roles = await db.query('roles');
    if (roles.isEmpty) {
      await roleService.insertDefaultRoles();
    }
  }

  // Fetch roles from database and store them in SharedPreferences
  Future<void> _fetchAndStoreRoles() async {
    final db = await _dbService.database;
    final roleService = _dbService.getRoleService();

    final roles = await db.query('roles');
    final roleNames = roles.map((role) => role['name'].toString()).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_roles', roleNames);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              "Find Shop",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
