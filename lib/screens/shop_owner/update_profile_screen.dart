import 'package:find_shop/models/user.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  final User user;

  const UpdateProfileScreen({super.key, required this.user});

  @override
  UpdateProfileScreenState createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _emailController.text = widget.user.email;
    _contactController.text = widget.user.contact;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter new username',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username cannot be empty';
                  }
                  if (value.trim().length < 3) {
                    return 'Username must be at least 3 characters long';
                  }
                  return null;
                },
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
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter new email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email cannot be empty';
                  }
                  if (!value.trim().contains('@') ||
                      !value.trim().contains('.')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Contact:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent.shade700,
                ),
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  hintText: 'Enter new contact number',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Contact cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String newUsername = _usernameController.text.trim();
                    String newEmail = _emailController.text.trim();
                    String newContact =
                        _contactController.text.trim(); // Get contact

                    if (newUsername != widget.user.username ||
                        newEmail != widget.user.email ||
                        newContact != widget.user.contact) {
                      widget.user.updateUsername(newUsername);
                      widget.user.updateEmail(newEmail);
                      widget.user.updateContact(newContact); // Update contact

                      await Provider.of<UserProvider>(context, listen: false)
                          .updateUser(widget.user);

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } else {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Update Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
