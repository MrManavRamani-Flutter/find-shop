import 'package:find_shop/screens/customer/shops/shop_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/models/area.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/models/user.dart';

class AreaWiseShopListScreen extends StatefulWidget {
  final Area area;

  const AreaWiseShopListScreen({super.key, required this.area});

  @override
  AreaWiseShopListScreenState createState() => AreaWiseShopListScreenState();
}

class AreaWiseShopListScreenState extends State<AreaWiseShopListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Shop> filteredShops = [];

  @override
  void initState() {
    super.initState();
    _fetchShops();
    _searchController.addListener(() {
      _filterShops(_searchController.text);
    });
  }

  void _fetchShops() async {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await Future.wait([
      shopProvider.fetchShops(),
      userProvider.fetchUsers(),
    ]);

    setState(() {
      filteredShops = shopProvider.shops.where((shop) {
        final User user = userProvider.getUserByUserId(shop.userId!);
        return shop.areaId == widget.area.areaId &&
            (user.status == 1 || user.status == 3);
      }).toList();
    });
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
                ? const Center(child: Text("No shops found"))
                : ListView.builder(
                    itemCount: filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = filteredShops[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const Icon(Icons.storefront_rounded,
                              color: Colors.blue),
                          title: Text(shop.shopName ?? 'Unknown Shop'),
                          subtitle: Text(shop.address ?? 'No Address'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerShopDetailScreen(
                                    shopId: shop.shopId!, userId: shop.userId!),
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
