import 'package:find_shop/providers/favorite_shop_provider.dart';
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

class CustomerShopDetailScreen extends StatefulWidget {
  final int shopId;
  final int shopUserId;

  const CustomerShopDetailScreen(
      {super.key, required this.shopId, required this.shopUserId});

  @override
  CustomerShopDetailScreenState createState() =>
      CustomerShopDetailScreenState();
}

class CustomerShopDetailScreenState extends State<CustomerShopDetailScreen> {
  late ShopProvider _shopProvider;
  late UserProvider _userProvider;
  late ShopCategoryProvider _shopCategoryProvider;
  late CategoryProvider _categoryProvider;
  late AreaProvider _areaProvider;
  late FavoriteShopProvider
      _favoriteShopProvider;

  bool _isLoading = true;
  Shop? _shop;
  User? _user;
  Category? _category;
  Area? _area;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _favoriteShopProvider =
        Provider.of<FavoriteShopProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    _shopProvider = Provider.of<ShopProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _shopCategoryProvider =
        Provider.of<ShopCategoryProvider>(context, listen: false);
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _areaProvider = Provider.of<AreaProvider>(context, listen: false);

    await _shopProvider.fetchShopByUserId(widget.shopUserId);
    await _userProvider.fetchUsers();
    await _categoryProvider.fetchCategories();
    await _shopCategoryProvider.fetchCategoriesForShop(widget.shopId);
    await _areaProvider.fetchAreas();

    setState(() {
      _shop = _shopProvider.shop;
      _user = _userProvider.getUserByUserId(widget.shopUserId);

      if (_shop != null) {
        var shopCategory = _shopCategoryProvider.shopCategories
            .firstWhere((sc) => sc.shopId == _shop!.shopId);

        _category = _categoryProvider.categories
            .firstWhere((c) => c.catId == shopCategory.catId);

        _area =
            _areaProvider.areas.firstWhere((a) => a.areaId == _shop!.areaId);
      }

      // Fetch the favorite status for the shop
      _favoriteShopProvider.isFavorite(widget.shopId).then((value) {
        setState(() {
          isFavorite = value;
        });
      });

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
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
              color: isFavorite
                  ? Colors.red
                  : Colors.white, // Update color based on favorite status
            ),
            onPressed: () async {
              await _favoriteShopProvider.toggleFavoriteShop(widget.shopId);

              final message =
                  isFavorite ? 'Removed from favorites' : 'Added to favorites';

              // Fetch the updated favorite status and update the UI
              setState(() {
                isFavorite = !isFavorite;
              });

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            },
          ),
        ],
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
        ],
      ),
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

  Widget _buildOwnerInfo(User user) {
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
            _buildInfoRow(Icons.person, 'Name', user.username),
            _buildInfoRow(Icons.email, 'Email', user.email),
            _buildInfoRow(Icons.phone, 'Contact', user.contact),
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
