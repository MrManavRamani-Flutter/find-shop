import 'package:find_shop/models/category.dart';
import 'package:find_shop/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:find_shop/models/area.dart';
import 'package:find_shop/models/shop_category.dart';
import 'package:find_shop/providers/area_provider.dart';
import 'package:find_shop/providers/shop_category_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'update_profile_screen.dart';
import 'update_shop_screen.dart';
import 'package:provider/provider.dart';

class ShopOwnerProfileScreen extends StatefulWidget {
  const ShopOwnerProfileScreen({super.key});

  @override
  State<ShopOwnerProfileScreen> createState() => _ShopOwnerProfileScreenState();
}

class _ShopOwnerProfileScreenState extends State<ShopOwnerProfileScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    // Use Future.wait for concurrent data fetching
    await Future.wait([
      Provider.of<UserProvider>(context, listen: false).fetchLoggedInUser(),
      Provider.of<ShopProvider>(context, listen: false).fetchShops(),
      Provider.of<AreaProvider>(context, listen: false).fetchAreas(),
      Provider.of<ShopCategoryProvider>(context, listen: false)
          .fetchShopCategories(),
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories(),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);
    final areaProvider = Provider.of<AreaProvider>(context);
    final shopCategoryProvider = Provider.of<ShopCategoryProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    // Show loading indicator while fetching initial data
    if (_isLoading || userProvider.loggedInUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = userProvider.loggedInUser!;
    final shop = shopProvider.getShopByUserId(user.userId);

    // Handle the case where no shop is found
    if (shop.shopId == -1) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text('No shop associated with this user.'),
        ),
      );
    }

    final area = areaProvider.areas.firstWhere(
      (area) => area.areaId == shop.areaId,
      orElse: () => Area(areaId: 0, areaName: 'No Area'),
    );

    // Find the ShopCategory for this shop
    final shopCategory = shopCategoryProvider.shopCategories.firstWhere(
      (category) => category.shopId == shop.shopId,
      orElse: () => ShopCategory(shopCatId: 0, shopId: 0, catId: 0),
    );

    // Find the Category based on the catId in ShopCategory
    final category = categoryProvider.categories.firstWhere(
      (cat) => cat.catId == shopCategory.catId,
      orElse: () => Category(catId: 0, catName: 'Unknown', catDesc: ''),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/shop_home');
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar
            const CircleAvatar(
              radius: 60,
              backgroundImage:
                  AssetImage('assets/logo/user.png'), // Use user image asset
            ),
            const SizedBox(height: 20),

            // User Details Card
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.person, "Username", user.username),
                    _buildDetailRow(Icons.email, "Email", user.email),
                    _buildDetailRow(Icons.phone, "Contact", user.contact),
                    _buildStatusRow(user.status),
                  ],
                ),
              ),
            ),
            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen(user: user),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Shop Details Card
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.store, "Shop Name",
                        shop.shopName ?? 'No Shop Name'),
                    _buildDetailRow(Icons.location_on, "Address",
                        shop.address ?? 'No Address Provided'),
                    _buildDetailRow(Icons.map, "Area", area.areaName),
                    _buildDetailRow(
                        Icons.category, "Shop Category", category.catName),
                  ],
                ),
              ),
            ),

            // Edit Shop Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateShopScreen(
                        shop: shop,
                        areas: areaProvider.areas,
                        shopCategory: shopCategory,
                        categories: categoryProvider.categories,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Edit Shop',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            // Logout Button
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferencesHelper().clearUserData();
                  SharedPreferencesHelper().clearAuthToken();
                  SharedPreferencesHelper().clearLoginStatus();
                  await userProvider.logOut();

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Align icons and text top
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey, // Subtle title color
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87, // Slightly darker value color
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(int status) {
    String statusText;
    Color statusColor;

    switch (status) {
      case 1:
        statusText = "Approved";
        statusColor = Colors.green[700]!;
        break;
      case 3:
        statusText = "Pending";
        statusColor = Colors.orange[700]!;
        break;
      case 2:
        statusText = "Blocked";
        statusColor = Colors.red[700]!;
        break;
      default:
        statusText = "Unknown";
        statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.verified,
            color: statusColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Text(
            "Status:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
