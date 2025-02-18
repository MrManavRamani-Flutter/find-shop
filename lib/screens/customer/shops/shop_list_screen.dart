import 'package:find_shop/providers/favorite_shop_provider.dart';
import 'package:find_shop/screens/customer/shops/shop_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/models/user.dart';

class CustomerShopListScreen extends StatefulWidget {
  const CustomerShopListScreen({super.key});

  @override
  State<CustomerShopListScreen> createState() => _CustomerShopListScreenState();
}

class _CustomerShopListScreenState extends State<CustomerShopListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Shop> filteredShops = [];
  late FavoriteShopProvider _favoriteShopProvider;
  late ShopProvider _shopProvider;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _favoriteShopProvider =
        Provider.of<FavoriteShopProvider>(context, listen: false);
    _shopProvider = Provider.of<ShopProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    fetchShops();
  }

  // Fetching and filtering shops based on user status
  void fetchShops() async {
    await Future.wait([
      _shopProvider.fetchShops(),
      _userProvider.fetchUsers(),
    ]);

    setState(() {
      filteredShops = _shopProvider.shops.where((shop) {
        final User user = _userProvider.getUserByUserId(shop.userId!);
        return user.status == 1 || user.status == 3;
      }).toList();
    });
  }

  // Check if the shop is in the favorites list
  bool isShopFavorite(int shopId) {
    return _favoriteShopProvider.favoriteShops
        .any((favorite) => favorite.shopId == shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/customer_home');
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Available Shops',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildShopList()),
        ],
      ),
    );
  }

  // Search Bar Widget
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
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (query) {
          setState(() {
            _searchQuery = query.toLowerCase();
          });
        },
      ),
    );
  }

  // List of Shops with Search Filtering
  Widget _buildShopList() {
    final filteredList = filteredShops
        .where((shop) =>
            shop.shopName?.toLowerCase().contains(_searchQuery) ?? false)
        .toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Text(
          'No shops found',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final shop = filteredList[index];
        bool isFavorite =
            isShopFavorite(shop.shopId!); // Check if the shop is a favorite
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.storefront_rounded, color: Colors.blue),
            title: Text(
              shop.shopName ?? 'No Name',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                color: isFavorite
                    ? Colors.red
                    : Colors.black, // Update color based on favorite status
              ),
              onPressed: () async {
                // Toggle the favorite status of the shop
                await _favoriteShopProvider.toggleFavoriteShop(shop.shopId!);

                // Fetch the updated favorite list
                setState(() {});

                // Show snack bar message
                final message = isFavorite
                    ? 'Removed from favorites'
                    : 'Added to favorites';
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                }
              },
            ),
            subtitle: Text(shop.address ?? 'No Address available'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerShopDetailScreen(
                      shopId: shop.shopId!, shopUserId: shop.userId!),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
