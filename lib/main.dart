import 'package:flutter/material.dart';

import 'views/admin/admin_screen.dart';

void main() {
  runApp(const FindShopApp());
}

class FindShopApp extends StatelessWidget {
  const FindShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find Shop',
      home: AdminScreen(),
    );
  }
}
