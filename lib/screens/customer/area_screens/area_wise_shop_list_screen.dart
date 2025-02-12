import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/providers/favorite_shop_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/models/area.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/models/user.dart';
import 'package:find_shop/screens/customer/shops/shop_detail_screen.dart';

class AreaWiseShopListScreen extends StatefulWidget {
  final Area area;

  const AreaWiseShopListScreen({super.key, required this.area});

  @override
  State<AreaWiseShopListScreen> createState() => _AreaWiseShopListScreenState();
}

class _AreaWiseShopListScreenState extends State<AreaWiseShopListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Shop> filteredShops = [];
  int? loggedInUserId;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(() {
      _filterShops(_searchController.text);
    });
  }

  void _fetchData() async {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final favoriteShopProvider =
        Provider.of<FavoriteShopProvider>(context, listen: false);

    await Future.wait([
      shopProvider.fetchShops(),
      userProvider.fetchUsers(),
      favoriteShopProvider.fetchFavoriteShopsByUserId(),
    ]);

    setState(() {
      loggedInUserId = userProvider.loggedInUser?.userId;
      _updateFilteredShops();
    });
  }

  void _updateFilteredShops() {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      filteredShops = shopProvider.shops.where((shop) {
        final User user = userProvider.getUserByUserId(shop.userId!);
        return shop.areaId == widget.area.areaId &&
            (user.status == 1 || user.status == 3);
      }).toList();
    });
  }

  bool isShopFavorite(int shopId) {
    final favoriteShopProvider =
        Provider.of<FavoriteShopProvider>(context, listen: false);
    return favoriteShopProvider.favoriteShops
        .any((favorite) => favorite.shopId == shopId);
  }

  void _filterShops(String query) {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      filteredShops = shopProvider.shops.where((shop) {
        final User user = userProvider.getUserByUserId(shop.userId!);
        return shop.areaId == widget.area.areaId &&
            (user.status == 1 || user.status == 3) &&
            shop.shopName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  onPressed: () => _searchController.clear(),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: _filterShops,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.area.areaName,
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: filteredShops.isEmpty
                ? const Center(
                    child: Text(
                      "No shops found",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = filteredShops[index];
                      bool isFavorite = isShopFavorite(shop.shopId!);

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const Icon(Icons.storefront_rounded,
                              color: Colors.blue),
                          title: Text(shop.shopName ?? 'Unknown Shop'),
                          subtitle: Text(shop.address ?? 'No Address'),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isFavorite ? Colors.red : Colors.black,
                            ),
                            onPressed: () async {
                              final favoriteShopProvider =
                                  Provider.of<FavoriteShopProvider>(context,
                                      listen: false);
                              await favoriteShopProvider
                                  .toggleFavoriteShop(shop.shopId!);
                              setState(() {});
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(isFavorite
                                        ? 'Removed from favorites'
                                        : 'Added to favorites'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                          onTap: () {
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
