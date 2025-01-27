import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isLoading = false;
  int? _selectedRole;
  List<Map<String, dynamic>> _roles = [];

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roles = await authProvider.fetchRoles();  // Fetching roles from the backend
    setState(() {
      _roles = roles;
    });
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      setState(() => _isLoading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Calling the registerUser method in AuthProvider to register the user
      bool success = await authProvider.registerUser(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _contactController.text.trim(),
        _selectedRole!,  // The role is set as a foreign key
      );

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please log in.')),
        );
        Navigator.pop(context);  // Navigate to the login screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed. Email already exists.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title Text
              const Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Form Fields
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Username TextField
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter a username' : null,
                    ),
                    const SizedBox(height: 20),

                    // Email TextField
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty ? 'Enter a valid email' : null,
                    ),
                    const SizedBox(height: 20),

                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                    ),
                    const SizedBox(height: 20),

                    // Contact TextField
                    TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Enter your contact number' : null,
                    ),
                    const SizedBox(height: 20),

                    // Role Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedRole,
                      decoration: const InputDecoration(labelText: 'Select Role'),
                      items: _roles.map((role) {
                        return DropdownMenuItem<int>(
                          value: role['role_id'],
                          child: Text(role['role_name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedRole = value);
                      },
                      validator: (value) => value == null ? 'Please select a role' : null,
                    ),
                    const SizedBox(height: 30),

                    // Loading Indicator or Register Button
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Link to Login Screen
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Navigate to the login screen
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
