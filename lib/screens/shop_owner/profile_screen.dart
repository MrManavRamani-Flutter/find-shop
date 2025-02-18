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

class ShopOwnerProfileScreen extends StatelessWidget {
  const ShopOwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);
    final areaProvider = Provider.of<AreaProvider>(context);
    final shopCategoryProvider = Provider.of<ShopCategoryProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    // Fetch data if not already loaded
    if (userProvider.loggedInUser == null) {
      userProvider.fetchLoggedInUser();
    }
    if (shopProvider.shops.isEmpty) {
      shopProvider.fetchShops();
    }
    if (areaProvider.areas.isEmpty) {
      areaProvider.fetchAreas();
    }
    if (shopCategoryProvider.shopCategories.isEmpty) {
      shopCategoryProvider.fetchShopCategories();
    }
    if (categoryProvider.categories.isEmpty) {
      categoryProvider.fetchCategories();
    }

    // Show loading indicator if data is still being fetched
    if (userProvider.loggedInUser == null ||
        shopProvider.shops.isEmpty ||
        areaProvider.areas.isEmpty ||
        shopCategoryProvider.shopCategories.isEmpty ||
        categoryProvider.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = userProvider.loggedInUser!;
    final shop = shopProvider.getShopByUserId(user.userId);
    final area = areaProvider.areas.firstWhere(
        (area) => area.areaId == shop.areaId,
        orElse: () => Area(areaId: 0, areaName: 'No Area'));

    // Find the ShopCategory for this shop
    final shopCategory = shopCategoryProvider.shopCategories.firstWhere(
        (category) => category.shopId == shop.shopId,
        orElse: () => ShopCategory(shopCatId: 0, shopId: 0, catId: 0));

    // Find the Category based on the catId in ShopCategory
    final category = categoryProvider.categories.firstWhere(
        (cat) => cat.catId == shopCategory.catId,
        orElse: () => Category(catId: 0, catName: 'Unknown', catDesc: ''));

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/shop_home');
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar with a professional touch
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/logo/user.png', // Placeholder avatar
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Details Card with rounded edges
            Card(
              elevation: 6,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              shadowColor: Colors.blueAccent.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.person, "Username", user.username),
                    _buildDetailRow(Icons.email, "Email", user.email),
                    _buildDetailRow(Icons.phone, "Contact", user.contact),
                    // Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.verified,
                            color: user.status == 1
                                ? Colors.green
                                : (user.status == 3)
                                    ? Colors.orange
                                    : Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          user.status == 1
                              ? "Approved"
                              : (user.status == 3)
                                  ? "Pending"
                                  : "Blocked",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: user.status == 1
                                ? Colors.green[700]
                                : (user.status == 3)
                                    ? Colors.orange[700]
                                    : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                  backgroundColor: Colors.blue, // Change to a more vibrant blue
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Edit Profile',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),

            // Shop Details Card with clean typography
            Card(
              elevation: 6,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              shadowColor: Colors.greenAccent.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
            const SizedBox(height: 10),
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
                  backgroundColor: Colors.green, // Change to a deeper green
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Edit Shop',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),

            // Full-width Logout Button placed at the bottom
            const Spacer(),
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
                  backgroundColor: Colors.red, // Change to a more vibrant red
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Logout',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 10),
          Text(
            "$title:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
