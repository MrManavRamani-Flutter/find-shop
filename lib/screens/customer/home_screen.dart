import 'package:find_shop/models/category.dart';
import 'package:find_shop/providers/category_provider.dart';
import 'package:find_shop/screens/customer/category_screens/customer_category_shop_list_screen.dart';
import 'package:find_shop/screens/customer/shops/shop_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/models/user.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/providers/area_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:find_shop/screens/customer/area_screens/area_wise_shop_list_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<Shop> filteredShops = [];
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  void fetchShops() async {
    final userLoginProvider = Provider.of<UserProvider>(context, listen: false);
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    userLoginProvider.fetchLoggedInUser();

    await Future.wait([
      shopProvider.fetchShops(),
      userProvider.fetchUsers(),
      categoryProvider.fetchCategories(),
    ]);

    setState(() {
      filteredShops = shopProvider.shops.where((shop) {
        final User user = userProvider.getUserByUserId(shop.userId!);
        return user.status == 1 || user.status == 3;
      }).toList();
      categories = categoryProvider.categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Categories', '/customer_category_list'),
          _buildCategoryList(context),
          const SizedBox(height: 10),
          _buildSectionTitle('Available Areas', '/customer_area_list'),
          _buildAreaList(context),
          const SizedBox(height: 10),
          _buildSectionTitle('Available Shops', '/customer_shop_list'),
          _buildShopList(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Find Shop', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.blueAccent,
    );
  }

  // Build section title with "View All" button
  Widget _buildSectionTitle(String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          if (route.isNotEmpty)
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(route),
              child: const Text('View All',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  // Display filtered shops based on user status
  Widget _buildShopList(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredShops.length,
        itemBuilder: (ctx, index) =>
            _buildShopCard(filteredShops[index], context),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerCategoryShopListScreen(
                      selectedCategory: category,
                    ),
                  ),
                );
              },
              child: Chip(
                label: Text(category.catName),
                backgroundColor: Colors.blueAccent,
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  // Display areas in a horizontally scrollable list
  Widget _buildAreaList(BuildContext context) {
    return Consumer<AreaProvider>(
      builder: (context, areaProvider, child) {
        final areas = areaProvider.areas;
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: areas.length,
            itemBuilder: (context, index) =>
                _buildAreaCard(areas[index], context),
          ),
        );
      },
    );
  }

  // Shop card UI
  Widget _buildShopCard(Shop shop, BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerShopDetailScreen(
                    shopId: shop.shopId!, userId: shop.userId!),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.storefront_rounded,
                    size: 70, color: Colors.blue),
                const SizedBox(height: 10),
                Text(shop.shopName ?? 'No Name',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Area card UI
  Widget _buildAreaCard(area, BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AreaWiseShopListScreen(area: area)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.blue, size: 32),
                const SizedBox(height: 8),
                Text(area.areaName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Drawer UI with user profile and options
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          _buildDrawerItem(Icons.category, 'Category List',
              '/customer_category_list', context),
          _buildDrawerItem(
              Icons.location_on, 'Area List', '/customer_area_list', context),
          _buildDrawerItem(Icons.storefront_rounded, 'Shop List',
              '/customer_shop_list', context),
          const Spacer(),
          _buildLogoutItem(context),
        ],
      ),
    );
  }

  // Drawer header with user profile
  Widget _buildDrawerHeader(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userLoginProvider, child) {
        final loggedInUser = userLoginProvider.loggedInUser;
        return UserAccountsDrawerHeader(
          decoration: const BoxDecoration(color: Colors.blue),
          accountName: Text(loggedInUser?.username ?? 'Guest',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          accountEmail: Text(loggedInUser?.email ?? 'No email'),
          currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/logo/user.png')),
        );
      },
    );
  }

  // Drawer item UI
  Widget _buildDrawerItem(
      IconData icon, String title, String route, BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        onTap: () {
          Navigator.pushNamed(context, route).then(
            (value) => Navigator.pop(context),
          );
        },
      ),
    );
  }

  // Logout item in drawer
  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      title: const Text('Logout', style: TextStyle(color: Colors.white)),
      tileColor: Colors.red,
      onTap: () async {
        await SharedPreferencesHelper().clearUserData();
        await SharedPreferencesHelper().clearAuthToken();
        await SharedPreferencesHelper().clearLoginStatus();
        await Provider.of<UserProvider>(context, listen: false).logOut();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
    );
  }
}
