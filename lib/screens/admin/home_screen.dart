// screens/admin_home_screen.dart
import 'package:find_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/home_widgets/admin_app_bar.dart';
import 'widgets/home_widgets/admin_dashboard_body.dart';
import 'widgets/home_widgets/admin_drawer.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchLoggedInUser();

    return Scaffold(
      appBar: const AdminAppBar(),
      drawer: AdminDrawer(userProvider: userProvider),
      body: const AdminDashboardBody(),
    );
  }
}
