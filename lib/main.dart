import 'package:find_shop/views/splash_screen.dart';
import 'package:flutter/material.dart';

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
      home: SplashScreen(),
    );
  }
}
