import 'package:find_shop/screens/admin/shop/shop_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/providers/shop_provider.dart';

class ShopListScreen extends StatelessWidget {
  const ShopListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Shop List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder(
        future: Provider.of<ShopProvider>(context, listen: false)
            .fetchShopsByUserStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<ShopProvider>(
              builder: (context, shopProvider, child) {
                final shops = shopProvider.shops;
                if (shops.isEmpty) {
                  return const Center(child: Text('No shops found'));
                }
                return ListView.builder(
                  itemCount: shops.length,
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(20),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ShopDetailScreen(
                                  shopId: shop.shopId!, userId: shop.userId!),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(
                            Icons.storefront_rounded,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          shop.shopName!,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Address: ${shop.address}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
