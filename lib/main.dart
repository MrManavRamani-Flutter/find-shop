import 'package:find_shop/screens/admin/manage_users.dart';
import 'package:find_shop/screens/intro_screen/splash_screen.dart';

import 'providers/customer_provider.dart';
import 'providers/shop_owner_provider.dart';
import 'screens/admin/dashboard.dart';
import 'screens/auth/register_screen.dart';
import 'screens/customer/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ShopOwnerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find Shop',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        // Intro SplashScreen
        '/splash': (context) => const SplashScreen(),
        // Auth Login screen design....
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        // Customer screen Design....
        '/home': (context) => const HomeScreen(),
        //   Admin Screen Design....
        '/adminDashboard': (context) => const AdminDashboard(),
        '/manage_users': (context) => const ManageUsers(),
        // ShopOwner Screen Design....
      },
    );
  }
}
