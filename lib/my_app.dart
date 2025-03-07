import 'package:find_shop/providers/area_provider.dart';
import 'package:find_shop/providers/category_provider.dart';
import 'package:find_shop/providers/favorite_shop_provider.dart';
import 'package:find_shop/providers/product_provider.dart';
import 'package:find_shop/providers/shop_category_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/shop_review_provider.dart';
import 'package:find_shop/providers/upload_provider/upload_provider.dart';
import 'package:find_shop/screens/customer/about_screen.dart';
import 'package:find_shop/screens/shop_owner/about_screen.dart';
import 'package:find_shop/screens/admin/area/area_list_screen.dart';
import 'package:find_shop/screens/admin/category/category_list_screen.dart';
import 'package:find_shop/screens/admin/customer/customer_list_screen.dart';
import 'package:find_shop/screens/admin/home_screen.dart';
import 'package:find_shop/screens/admin/product/product_list_screen.dart';
import 'package:find_shop/screens/admin/profile_screen.dart';
import 'package:find_shop/screens/admin/shop/shop_list_screen.dart';
import 'package:find_shop/screens/admin/shop_owner/shop_owner_list_screen.dart';
import 'package:find_shop/screens/admin/upload_data/upload_data_screen.dart';
import 'package:find_shop/screens/customer/area_screens/area_list_screen.dart';
import 'package:find_shop/screens/customer/category_screens/category_list_screen.dart';
import 'package:find_shop/screens/customer/favorite_screens/favorite_shop_list_screen.dart';
import 'package:find_shop/screens/customer/home_screen.dart';
import 'package:find_shop/screens/customer/product_screen/product_list_screen.dart';
import 'package:find_shop/screens/customer/profile_screen.dart';
import 'package:find_shop/screens/customer/review_screen/add_review_screen.dart';
import 'package:find_shop/screens/customer/shops/shop_list_screen.dart';
import 'package:find_shop/screens/register_screen.dart';
import 'package:find_shop/screens/shop_owner/home_screen.dart';
import 'package:find_shop/screens/shop_owner/product_screen/product_list_screen.dart';
import 'package:find_shop/screens/shop_owner/profile_screen.dart';
import 'package:find_shop/screens/shop_owner/review_screen/review_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/role_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Upload Data using excel file
        ChangeNotifierProvider(create: (_) => UploadProvider()),
        // Database Tables..
        ChangeNotifierProvider(create: (_) => AreaProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ShopCategoryProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteShopProvider()),
        ChangeNotifierProvider(create: (_) => ShopReviewProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Find Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: isLoggedIn ? '/splash' : '/login',
        routes: {
          // Splash and login screens
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/about_customer': (context) => const AboutScreen(),
          '/about_shop': (context) => const AboutShopScreen(),

          // Customer Screens
          '/customer_home': (context) => const CustomerHomeScreen(),
          '/customer_profile': (context) => const CustomerProfileScreen(),
          '/customer_area_list': (context) => const CustomerAreaListScreen(),
          '/customer_category_list': (context) =>
              const CustomerCategoryListScreen(),
          '/customer_shop_list': (context) => const CustomerShopListScreen(),
          '/customer_product_list': (context) =>
              const CustomerProductListScreen(),
          '/customer_favorite_list': (context) =>
              const CustomerFavoriteShopListScreen(),
          '/customer_add_review': (context) => CustomerAddReviewScreen(
              shopId: ModalRoute.of(context)!.settings.arguments as int),

          // Shop Owner Screens
          '/shop_home': (context) => const ShopOwnerHomeScreen(),
          '/shop_profile': (context) => const ShopOwnerProfileScreen(),
          '/shop_review_list': (context) => const ShopReviewListScreen(),
          '/shop_product_list': (context) => const ShopProductListScreen(),

          // Admin Screens
          '/dashboard': (context) => const AdminHomeScreen(),
          '/admin_profile': (context) => const AdminProfileScreen(),
          '/customers_list': (context) => const CustomersListScreen(),
          '/shop_owners_list': (context) => const ShopOwnerListScreen(),
          '/areas_list': (context) => const AreaListScreen(),
          '/categories_list': (context) => const CategoryListScreen(),
          '/shop_list': (context) => const ShopListScreen(),
          '/product_list': (context) => const AdminProductListScreen(),
          '/upload_data': (context) => const UploadDataScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
