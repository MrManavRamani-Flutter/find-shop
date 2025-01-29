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
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactController = TextEditingController();

  bool _isLoading = false;
  int? _selectedRole;
  late Future<List<Map<String, dynamic>>> _rolesFuture;

  @override
  void initState() {
    super.initState();
    _rolesFuture = _fetchRoles();
  }

  Future<List<Map<String, dynamic>>> _fetchRoles() async {
    return await Provider.of<AuthProvider>(context, listen: false).fetchRoles();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool success = await authProvider.registerUser(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _contactController.text.trim(),
        _selectedRole!,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Registration successful!'
              : 'Registration failed. Email already exists.'),
        ),
      );
      if (success) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _buildRegisterForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _usernameController,
            label: 'Username',
            icon: Icons.person,
            validator: (value) => value!.isEmpty ? 'Enter a username' : null,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock,
            obscureText: true,
            validator: (value) => value!.length < 6
                ? 'Password must be at least 6 characters'
                : null,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _contactController,
            label: 'Contact Number',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value!.isEmpty ? 'Enter your contact number' : null,
          ),
          const SizedBox(height: 20),
          _buildRoleDropdown(),
          const SizedBox(height: 30),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
          const SizedBox(height: 20),
          _buildLoginNavigation(),
        ],
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _rolesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Text("No roles found");
        }
        return DropdownButtonFormField<int>(
          value: _selectedRole,
          decoration: const InputDecoration(labelText: 'Select Role'),
          items: snapshot.data!.map((role) {
            return DropdownMenuItem<int>(
              value: role['role_id'],
              child: Text(role['role_name']),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedRole = value),
          validator: (value) => value == null ? 'Please select a role' : null,
        );
      },
    );
  }

  Widget _buildLoginNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? ', style: TextStyle(fontSize: 16)),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Login',
              style: TextStyle(fontSize: 16, color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
