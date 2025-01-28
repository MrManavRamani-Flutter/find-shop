import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  CustomerListScreenState createState() => CustomerListScreenState();
}

class CustomerListScreenState extends State<CustomerListScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<UserModel> _customers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  // Fetch customers from the database
  Future<void> _fetchCustomers() async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'role_id = ?',
      whereArgs: [1], // Assuming role_id = 1 is for customers
    );

    setState(() {
      _customers = result.map((data) => UserModel.fromMap(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _customers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                return ListTile(
                  title: Text(customer.username),
                  subtitle: Text(customer.email),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    // Handle customer details navigation
                  },
                );
              },
            ),
    );
  }
}
