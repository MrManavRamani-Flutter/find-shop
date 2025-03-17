import 'package:find_shop/screens/customer/shops/shop_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/shop.dart';
import '../../models/user.dart';
import '../../providers/area_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/shop_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/shared_preferences_helper.dart';
import 'area_screens/area_wise_shop_list_screen.dart';
import 'category_screens/customer_category_shop_list_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<Shop> filteredShops = [];

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final userLoginProvider = Provider.of<UserProvider>(context, listen: false);
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    userLoginProvider.fetchLoggedInUser();

    await Future.wait([
      shopProvider.fetchTop5Shops(),
      userProvider.fetchUsers(),
      categoryProvider.fetchTop5Categories(),
    ]);

    setState(() {
      filteredShops = shopProvider.top5shops.where((shop) {
        final User user = userProvider.getUserByUserId(shop.userId!);
        return user.status == 1 || user.status == 3;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Categories', '/customer_category_list'),
              _buildCategoryGrid(context),
              _buildSectionTitle('Available Areas', '/customer_area_list'),
              _buildAreaGrid(context),
              _buildSectionTitle('Available Shops', '/customer_shop_list'),
              _buildShopGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  // Category Grid
  Widget _buildCategoryGrid(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categories = categoryProvider.top5categories;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
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
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent.shade100,
                      ),
                      child: const Icon(
                        Icons.category,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        category.catName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Area Grid
  Widget _buildAreaGrid(BuildContext context) {
    return Consumer<AreaProvider>(
      builder: (context, areaProvider, child) {
        return FutureBuilder<void>(
          future: areaProvider.fetchTop5Areas(),
          builder: (context, snapshot) {
            final areas = areaProvider.top5areas;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: areas.length,
              itemBuilder: (context, index) =>
                  _buildAreaCard(areas[index], context),
            );
          },
        );
      },
    );
  }

  // Shop Grid
  Widget _buildShopGrid(BuildContext context) {
    return Consumer<ShopProvider>(
      builder: (context, shopProvider, child) {
        return FutureBuilder<void>(
          future: shopProvider.fetchTop5Shops(),
          builder: (context, snapshot) {
            final filteredShops = shopProvider.top5shops;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: filteredShops.length,
              itemBuilder: (ctx, index) => _buildShopCard(
                shop: filteredShops[index],
                context: context,
              ),
            );
          },
        );
      },
    );
  }

  // Shop Card UI
  Widget _buildShopCard({required Shop shop, required BuildContext context}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          if (shop.shopId == null || shop.userId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Shop details are incomplete!")),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerShopDetailScreen(
                shopId: shop.shopId!,
                shopUserId: shop.userId!,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.storefront_rounded,
                  size: 50, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                shop.shopName ?? 'No Name',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Area Card UI
  Widget _buildAreaCard(area, BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AreaWiseShopListScreen(area: area),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.blue, size: 32),
              const SizedBox(height: 8),
              Text(
                area.areaName,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Drawer UI
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          _buildDrawerItem(Icons.shopping_cart, 'Product List',
              '/customer_product_list', context),
          _buildDrawerItem(Icons.storefront_rounded, 'Shop List',
              '/customer_shop_list', context),
          _buildDrawerItem(Icons.category, 'Category List',
              '/customer_category_list', context),
          _buildDrawerItem(
              Icons.location_on, 'Area List', '/customer_area_list', context),
          _buildDrawerItem(
              Icons.favorite, 'Favorite', '/customer_favorite_list', context),
          _buildDrawerItem(
              Icons.account_box, 'Profile', '/customer_profile', context),
          _buildDrawerItem(Icons.perm_device_info_rounded, 'About',
              '/about_customer', context),
          const Spacer(),
          _buildLogoutItem(context),
        ],
      ),
    );
  }

  // Drawer Header
  Widget _buildDrawerHeader(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userLoginProvider, child) {
        final loggedInUser = userLoginProvider.loggedInUser;
        return InkWell(
          onTap: () => Navigator.of(context).pushNamed('/customer_profile'),
          child: UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            accountName: Text(
              loggedInUser?.username ?? 'Guest',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(loggedInUser?.email ?? 'No email'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/logo/user.png'),
            ),
          ),
        );
      },
    );
  }

  // Drawer Item
  Widget _buildDrawerItem(
      IconData icon, String title, String route, BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        onTap: () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }

  // Logout Item
  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      tileColor: Colors.red,
      trailing: const Icon(Icons.logout_outlined, color: Colors.white),
      onTap: () async {
        await SharedPreferencesHelper().clearUserData();
        await SharedPreferencesHelper().clearAuthToken();
        await SharedPreferencesHelper().clearLoginStatus();
        if (context.mounted) {
          await Provider.of<UserProvider>(context, listen: false).logOut();
        }
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Find Shop', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.blueAccent,
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (route.isNotEmpty)
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(route),
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
