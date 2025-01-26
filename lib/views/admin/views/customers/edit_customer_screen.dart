import 'package:flutter/material.dart';
import '../../../../data/store_data.dart';
// import '../../../../database_helper/database_helper.dart';
import '../../../../models/user_model/user.dart';

class EditCustomerScreen extends StatefulWidget {
  final User customer;

  const EditCustomerScreen({super.key, required this.customer});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  // late final DatabaseHelper _dbHelper;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    // _dbHelper = DatabaseHelper();
    _usernameController = TextEditingController(text: widget.customer.username);
    _emailController = TextEditingController(text: widget.customer.email);
    _contactController = TextEditingController(text: widget.customer.contact);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _updateCustomer() async {
    if (_formKey.currentState!.validate()) {
      final updatedCustomer = widget.customer.copyWith(
        username: _usernameController.text,
        email: _emailController.text,
        contact: _contactController.text,
      );
      // await _dbHelper.updateCustomer(updatedCustomer);
      // Fetch data every time the app opens
      fetchDataAndStore();
      Navigator.pop(context, updatedCustomer);  // Return updated customer to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Customer',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _usernameController,
                labelText: 'Username',
                validator: (value) =>
                value!.isEmpty ? 'Username cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) =>
                value!.isEmpty ? 'Email cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _contactController,
                labelText: 'Contact',
                validator: (value) =>
                value!.isEmpty ? 'Contact cannot be empty' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateCustomer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text('Save Changes',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }
}
