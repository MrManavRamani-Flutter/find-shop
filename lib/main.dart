import 'package:find_shop/database/app_database.dart';
import 'package:find_shop/providers/area_provider.dart';
import 'package:find_shop/providers/category_provider.dart';
import 'package:find_shop/providers/shop_category_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/screens/admin/area/area_list_screen.dart';
import 'package:find_shop/screens/admin/category/category_list_screen.dart';
import 'package:find_shop/screens/admin/customer/customer_list_screen.dart';
import 'package:find_shop/screens/admin/home_screen.dart';
import 'package:find_shop/screens/admin/profile_screen.dart';
import 'package:find_shop/screens/admin/shop/shop_list_screen.dart';
import 'package:find_shop/screens/admin/shop_owner/shop_owner_list_screen.dart';
import 'package:find_shop/screens/customer/home_screen.dart';
import 'package:find_shop/screens/customer/profile_screen.dart';
import 'package:find_shop/screens/register_screen.dart';
import 'package:find_shop/screens/shop_owner/home_screen.dart';
import 'package:find_shop/screens/shop_owner/profile_screen.dart';
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
        ChangeNotifierProvider(create: (_) => AreaProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ShopCategoryProvider()),
      ],
      child: MaterialApp(
        title: 'Find Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Navigate based on login status
        initialRoute: isLoggedIn ? '/splash' : '/login',
        routes: {
          // basic screen -------
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          // ---------------------------------------------------------------

          // Customer Screen --------
          '/customer_home': (context) => const CustomerHomeScreen(),
          '/customer_profile': (context) => const CustomerProfileScreen(),
          // ---------------------------------------------------------------

          // Shop Owner Screen -------
          '/shop_home': (context) => const ShopOwnerHomeScreen(),
          '/shop_profile': (context) => const ShopOwnerProfileScreen(),
          // ---------------------------------------------------------------

          // Admin Screen --------
          '/dashboard': (context) => const AdminHomeScreen(),
          '/admin_profile': (context) => const AdminProfileScreen(),
          '/customers_list': (context) => const CustomersListScreen(),
          '/shop_owners_list': (context) => const ShopOwnerListScreen(),
          '/areas_list': (context) => const AreaListScreen(),
          '/categories_list': (context) => const CategoryListScreen(),
          '/shop_list': (context) => const ShopListScreen(),
          // ---------------------------------------------------------------
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
