// widgets/admin_drawer_header.dart
import 'package:find_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDrawerHeader extends StatelessWidget {
  final UserProvider userProvider;

  const AdminDrawerHeader({super.key, required this.userProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      final loggedInUser = userProvider.loggedInUser;
      return InkWell(
        onTap: () {
          if (loggedInUser != null) {
            Navigator.pushReplacementNamed(context, '/admin_profile');
          }
        },
        child: UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: Colors.blueAccent),
          accountName: Text(
            loggedInUser?.username ?? 'Guest',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          accountEmail: Text(
            loggedInUser?.email ?? 'No email',
            style: const TextStyle(color: Colors.white70),
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage('assets/logo/user.png'),
          ),
        ),
      );
    });
  }
}