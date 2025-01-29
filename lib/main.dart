import 'package:find_shop/database/app_database.dart';
import 'package:find_shop/screens/admin/home_screen.dart';
import 'package:find_shop/screens/customer/home_screen.dart';
import 'package:find_shop/screens/customer/profile_screen.dart';
import 'package:find_shop/screens/register_screen.dart';
import 'package:find_shop/screens/shop_owner/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/shared_preferences_helper.dart';
import 'providers/user_provider.dart';
import 'providers/role_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await AppDatabase().database;

  // Initialize SharedPreferences and check if the user is logged in
  bool isLoggedIn = await SharedPreferencesHelper().isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
      ],
      child: MaterialApp(
        title: 'Find Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Navigate based on login status
        initialRoute: isLoggedIn ? '/' : '/login',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/customer_profile': (context) => const CustomerProfileScreen(),
          '/customer_home': (context) => const CustomerHomeScreen(),
          '/shop_home': (context) => const ShopOwnerHomeScreen(),
          '/dashboard': (context) => const AdminHomeScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
