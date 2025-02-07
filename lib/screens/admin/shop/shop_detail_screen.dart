import 'package:find_shop/models/shop_review.dart';
import 'package:find_shop/providers/shop_review_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/providers/shop_category_provider.dart';
import 'package:find_shop/providers/category_provider.dart';
import 'package:find_shop/providers/area_provider.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/models/user.dart';
import 'package:find_shop/models/category.dart';
import 'package:find_shop/models/area.dart';
import 'package:intl/intl.dart';


class ShopDetailScreen extends StatefulWidget {
  final int shopId;
  final int userId;

  const ShopDetailScreen(
      {super.key, required this.shopId, required this.userId});

  @override
  ShopDetailScreenState createState() => ShopDetailScreenState();
}

class ShopDetailScreenState extends State<ShopDetailScreen> {
  late ShopProvider _shopProvider;
  late UserProvider _userProvider;
  late ShopCategoryProvider _shopCategoryProvider;
  late CategoryProvider _categoryProvider;
  late AreaProvider _areaProvider;
  late ShopReviewProvider _shopReviewProvider;

  bool _isLoading = true;
  Shop? _shop;
  User? _user;
  Category? _category;
  Area? _area;
  List<ShopReview> reviews = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }
  String _formatDateTime(String reviewDate) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm'); // Customize the format

    // Parse the reviewDate string into a DateTime object
    DateTime parsedDate = DateTime.tryParse(reviewDate) ?? DateTime.now(); // If parsing fails, fallback to current date/time

    return formatter.format(parsedDate);
  }
  Future<void> _fetchData() async {
    _shopProvider = Provider.of<ShopProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _shopCategoryProvider =
        Provider.of<ShopCategoryProvider>(context, listen: false);
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _areaProvider = Provider.of<AreaProvider>(context, listen: false);
    _shopReviewProvider =
        Provider.of<ShopReviewProvider>(context, listen: false);

    await _shopProvider.fetchShopByUserId(widget.userId);
    await _userProvider.fetchUsers();
    await _categoryProvider.fetchCategories();
    await _shopCategoryProvider.fetchCategoriesForShop(widget.shopId);
    await _areaProvider.fetchAreas();
    await _shopReviewProvider.fetchShopReviewsByShopId(widget.shopId);

    setState(() {
      _shop = _shopProvider.shop;
      _user = _userProvider.getUserByUserId(widget.userId);
      reviews = _shopReviewProvider.shopReviews;

      if (_shop != null) {
        var shopCategory = _shopCategoryProvider.shopCategories
            .firstWhere((sc) => sc.shopId == _shop!.shopId);

        _category = _categoryProvider.categories
            .firstWhere((c) => c.catId == shopCategory.catId);

        _area = _areaProvider.areas.firstWhere(
          (a) => a.areaId == _shop!.areaId,
          orElse: () => Area(areaId: -1, areaName: "No Area"),
        );
      }

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Shop Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _shop == null || _shop!.shopId == -1
              ? const Center(child: Text('Shop details not available'))
              : _buildShopProfile(),
    );
  }

  Widget _buildShopProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _user != null ? _buildOwnerInfo(_user!) : Container(),
          const SizedBox(height: 20),
          _buildShopDetails(),
          const SizedBox(height: 20),
          // Review Section with redesigned UI
          _buildReviewCard(),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Customer Reviews'),
            const SizedBox(height: 10),
            // Show a divider to separate title and reviews
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),
            _buildReviewList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);


    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        final user = userProvider.getUserByUserId(review.userId);
        final username = user.username;

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Row
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/logo/user.png'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(
                            review.rating.toInt(), // Convert double to int
                            (index) => const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                          ) +
                          List.generate(
                            (5 - review.rating.toInt()),
                            (index) => const Icon(Icons.star_border,
                                color: Colors.grey, size: 18),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Review Comment
                Text(
                  review.comment,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.5),
                ),
                const SizedBox(height: 12),
                // Date of Review (can show when the review was posted)
                Text(
                  'Posted on: ${_formatDateTime(review.reviewDate)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.store, size: 50, color: Colors.blueAccent),
        ),
        const SizedBox(height: 10),
        Text(
          _shop!.shopName ?? 'No Name',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          _category != null ? _category!.catName : "No Category",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildOwnerInfo(User shopUser) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Owner Information'),
            const SizedBox(height: 10),
            _buildInfoRow(Icons.person, 'Name', shopUser.username),
            _buildInfoRow(Icons.email, 'Email', shopUser.email),
            _buildInfoRow(Icons.phone, 'Contact', shopUser.contact),
          ],
        ),
      ),
    );
  }

  Widget _buildShopDetails() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Shop Details'),
            const SizedBox(height: 10),
            _buildInfoRow(
                Icons.location_on, 'Address', _shop!.address ?? 'No Address'),
            _buildInfoRow(Icons.map, 'Area', _area?.areaName ?? 'No Area'),
            // Display Area Name
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
