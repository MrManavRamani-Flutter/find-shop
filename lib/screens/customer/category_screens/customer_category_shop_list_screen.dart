import 'package:find_shop/database/shop_database_helper.dart';
import 'package:find_shop/models/category.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/providers/favorite_shop_provider.dart';
import 'package:find_shop/screens/customer/shops/shop_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerCategoryShopListScreen extends StatefulWidget {
  final Category selectedCategory;

  const CustomerCategoryShopListScreen({
    super.key,
    required this.selectedCategory,
  });

  @override
  State<CustomerCategoryShopListScreen> createState() =>
      _CustomerCategoryShopListScreenState();
}

class _CustomerCategoryShopListScreenState
    extends State<CustomerCategoryShopListScreen> {
  List<Shop> _shops = [];
  List<Shop> _filteredShops = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  late FavoriteShopProvider _favoriteShopProvider;

  @override
  void initState() {
    super.initState();
    _fetchShopsByCategory();
    _favoriteShopProvider =
        Provider.of<FavoriteShopProvider>(context, listen: false);
    _searchController.addListener(_filterShops);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchShopsByCategory() async {
    final shopDbHelper = ShopDatabaseHelper();
    final shops =
        await shopDbHelper.getShopsByCategory(widget.selectedCategory.catId!);
    setState(() {
      _shops = shops;
      _filteredShops = shops;
      _isLoading = false;
    });
  }

  bool isShopFavorite(int shopId) {
    return _favoriteShopProvider.favoriteShops
        .any((favorite) => favorite.shopId == shopId);
  }

  void _filterShops() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredShops = _shops
          .where((shop) => shop.shopName!.toLowerCase().contains(query))
          .toList();
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Shop...',
          prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectedCategory.catName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: _filteredShops.isEmpty
                      ? const Center(
                          child: Text(
                            'No shops found in this category',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredShops.length,
                          itemBuilder: (context, index) {
                            final shop = _filteredShops[index];
                            bool isFavorite = isShopFavorite(shop.shopId!);
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: ListTile(
                                leading: const Icon(Icons.store,
                                    color: Colors.blueAccent),
                                title: Text(shop.shopName!,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    shop.address ?? 'No address available',
                                    style: const TextStyle(color: Colors.grey)),
                                trailing: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: isFavorite
                                        ? Colors.red
                                        : Colors
                                            .black, // Update color based on favorite status
                                  ),
                                  onPressed: () async {
                                    // Toggle the favorite status of the shop
                                    await _favoriteShopProvider
                                        .toggleFavoriteShop(shop.shopId!);

                                    // Fetch the updated favorite list
                                    setState(() {});

                                    // Show snack bar message
                                    final message = isFavorite
                                        ? 'Removed from favorites'
                                        : 'Added to favorites';
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(message)));
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerShopDetailScreen(
                                              shopId: shop.shopId!,
                                              shopUserId: shop.userId!),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
