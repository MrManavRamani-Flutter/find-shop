import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/shop_review_provider.dart';
import 'package:find_shop/providers/product_provider.dart'; // Import ProductProvider
import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopOwnerHomeScreen extends StatefulWidget {
  const ShopOwnerHomeScreen({super.key});

  @override
  ShopOwnerHomeScreenState createState() => ShopOwnerHomeScreenState();
}

class ShopOwnerHomeScreenState extends State<ShopOwnerHomeScreen> {
  int? shopId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final shopProvider = Provider.of<ShopProvider>(context, listen: false);
      final shopReviewProvider =
          Provider.of<ShopReviewProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(context,
          listen: false); // ProductProvider

      // Fetch logged-in user
      await userProvider.fetchLoggedInUser();
      final loggedInUser = userProvider.loggedInUser;

      if (loggedInUser != null) {
        await shopProvider.fetchShopByUserId(loggedInUser.userId);
        if (shopProvider.shop != null) {
          shopId = shopProvider.shop!.shopId;
          // Fetch review count
          await shopReviewProvider.fetchShopReviewCount(shopId!);
          // Fetch product count by shopId
          await productProvider
              .countProductsByShopId(shopId!); // Count products
        }
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Find Shop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      drawer: _buildDrawer(context, userProvider),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final loggedInUser = userProvider.loggedInUser;
    final productProvider = Provider.of<ProductProvider>(context);

    if (loggedInUser == null) {
      return const Center(
        child: Text(
          'Please log in to view your shop details.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          if (shopId != null)
            Column(
              children: [
                Consumer<ShopReviewProvider>(
                  builder: (context, shopReviewProvider, child) {
                    return _buildReviewCard(shopReviewProvider.reviewCount);
                  },
                ),
                const SizedBox(height: 16),
                _buildProductCountCard(productProvider.productCountByShopId),
                // Display product count card
              ],
            )
          else
            const Text(
              'No shop found for this user.',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
        ],
      ),
    );
  }

  // Build card for displaying total reviews
  Widget _buildReviewCard(int reviewCount) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/shop_review_list');
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 40, color: Colors.amber),
              const SizedBox(height: 10),
              const Text(
                'Total Reviews',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$reviewCount',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build card for displaying product count
  Widget _buildProductCountCard(int productCount) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/shop_product_list', arguments: shopId)
            .then(
              (value) => _fetchData(), // Refresh data after navigating back
            );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.production_quantity_limits,
                  size: 40, color: Colors.green),
              const SizedBox(height: 10),
              const Text(
                'Total Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$productCount',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, UserProvider userProvider) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context, userProvider),
          ListTile(
            leading: const Icon(Icons.person), // Add leading icon
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/shop_profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits),
            // Add leading icon
            title: const Text('Product'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/shop_product_list',
                  arguments: shopId);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            // Add leading icon
            title: const Text('Review'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/shop_review_list',
                  arguments: shopId);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline), // Add leading icon
            title: const Text('About'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/about_shop');
            },
          ),
          const Spacer(),
          ListTile(
            trailing: const Icon(Icons.logout, color: Colors.white),
            // Icon with white color
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            tileColor: Colors.red,
            onTap: () async {
              await _logout(context, userProvider);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, UserProvider userProvider) {
    final loggedInUser = userProvider.loggedInUser;

    return InkWell(
      onTap: () {
        if (loggedInUser != null) {
          Navigator.pushReplacementNamed(context, '/shop_profile');
        }
      },
      child: UserAccountsDrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
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
  }

  Future<void> _logout(BuildContext context, UserProvider userProvider) async {
    SharedPreferencesHelper().clearUserData();
    SharedPreferencesHelper().clearAuthToken();
    SharedPreferencesHelper().clearLoginStatus();

    await userProvider.logOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
