// widgets/admin_dashboard_body.dart
import 'package:flutter/material.dart';

import 'admin_dashboard_card.dart';

class AdminDashboardBody extends StatelessWidget {
  const AdminDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          AdminDashboardCard(
            title: 'Customers',
            icon: Icons.people,
            onTap: () => Navigator.pushNamed(context, '/customers_list'),
          ),
          AdminDashboardCard(
            title: 'Shop Owners',
            icon: Icons.contact_mail_outlined,
            onTap: () => Navigator.pushNamed(context, '/shop_owners_list'),
          ),
          AdminDashboardCard(
            title: 'Registered Areas',
            icon: Icons.location_on,
            onTap: () => Navigator.pushNamed(context, '/areas_list'),
          ),
          AdminDashboardCard(
            title: 'Shop Category',
            icon: Icons.category,
            onTap: () => Navigator.pushNamed(context, '/categories_list'),
          ),
          AdminDashboardCard(
            title: 'Shop List',
            icon: Icons.storefront_rounded,
            onTap: () => Navigator.pushNamed(context, '/shop_list'),
          ),
          AdminDashboardCard(
            title: 'Product List',
            icon: Icons.shopping_cart,
            onTap: () => Navigator.pushNamed(context, '/product_list'),
          ),
        ],
      ),
    );
  }
}
