import 'package:flutter/material.dart';
import 'package:find_shop/views/admin/admin_screen.dart';
import 'package:find_shop/views/shop_owner/shop_screen.dart';
import 'package:find_shop/views/customer/customer_screen.dart';
import 'package:find_shop/views/register_screen.dart';
import '../data/global_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String userType = 'Customer'; // Default selected user type
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Use the login function from global_data.dart
    final user = login(username, password, userType);

    if (user.isNotEmpty) {
      // Navigate to role-based screens
      switch (user['role']) {
        case 'Customer':
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomerScreen(),
              ));
          break;
        case 'ShopOwner':
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ShopScreen(),
              ));
          break;
        case 'Admin':
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminScreen(),
              ));
          break;
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid credentials or role selection."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              // Find Shop Heading
              const Text(
                "Find Shop",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Username / Email / Phone Number
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Role Selection
              RadioListTile<String>(
                title: const Text("Customer"),
                value: 'Customer',
                groupValue: userType,
                onChanged: (value) {
                  setState(() {
                    userType = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text("Shop Owner"),
                value: 'ShopOwner',
                groupValue: userType,
                onChanged: (value) {
                  setState(() {
                    userType = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text("Admin"),
                value: 'Admin',
                groupValue: userType,
                onChanged: (value) {
                  setState(() {
                    userType = value!;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Login Button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // New User? Create Account
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to registration page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "New User? Create Account",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal,
                      decoration: TextDecoration.underline,
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

class RoleScreen extends StatelessWidget {
  final String title;

  const RoleScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          'Welcome to $title',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
