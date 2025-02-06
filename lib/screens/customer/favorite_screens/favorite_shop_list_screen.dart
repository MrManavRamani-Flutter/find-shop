import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/providers/favorite_shop_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/screens/customer/shops/shop_detail_screen.dart';

class CustomerFavoriteShopListScreen extends StatefulWidget {
  const CustomerFavoriteShopListScreen({super.key});

  @override
  State<CustomerFavoriteShopListScreen> createState() =>
      _CustomerFavoriteShopListScreenState();
}

class _CustomerFavoriteShopListScreenState
    extends State<CustomerFavoriteShopListScreen> {
  bool _isLoading = true;
  List<Shop> _favoriteShopList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fetch both favorite shops and all shops and update the state
  Future<void> fetchData() async {
    await Future.wait([
      Provider.of<FavoriteShopProvider>(context, listen: false)
          .fetchFavoriteShopsByUserId(),
      Provider.of<ShopProvider>(context, listen: false).fetchShops(),
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteShopProvider = Provider.of<FavoriteShopProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);

    // Filter the shops to show only those that are in the favorites list
    final favoriteShops = favoriteShopProvider.favoriteShops;
    final allShops = shopProvider.shops;

    _favoriteShopList = allShops
        .where((shop) => favoriteShops.any((fav) => fav.shopId == shop.shopId))
        .toList();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // this code not proper design.....*

    // if (_favoriteShopList.isEmpty) {
    //   return const Center(
    //     child: Text(
    //       'No favorite shops yet',
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Shops',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: _favoriteShopList.isEmpty
          ? const Center(
              child: Text(
                'No favorite shops yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favoriteShopList.length,
              itemBuilder: (context, index) {
                final shop = _favoriteShopList[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.storefront_rounded,
                        color: Colors.blueAccent),
                    title: Text(
                      shop.shopName ?? 'No Name',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(shop.address ?? 'No Address available'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () async {
                        await favoriteShopProvider
                            .toggleFavoriteShop(shop.shopId!);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Removed from favorites'),
                              duration: Duration(seconds: 2),
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
    );
  }
}
