import 'package:find_shop/screens/customer/area_screens/area_wise_shop_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/providers/area_provider.dart';

class CustomerAreaListScreen extends StatefulWidget {
  const CustomerAreaListScreen({super.key});

  @override
  State<CustomerAreaListScreen> createState() => _CustomerAreaListScreenState();
}

class _CustomerAreaListScreenState extends State<CustomerAreaListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<AreaProvider>(context, listen: false).fetchAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Areas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildAreaList()),
        ],
      ),
    );
  }

  //  Search Bar Widget
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Area...',
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

  //  List of Areas with Search Filtering
  Widget _buildAreaList() {
    return Consumer<AreaProvider>(
      builder: (context, areaProvider, child) {
        final areas = areaProvider.areas
            .where((area) => area.areaName.toLowerCase().contains(_searchQuery))
            .toList();

        if (areas.isEmpty) {
          return const Center(
            child: Text(
              'No areas found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: areas.length,
          itemBuilder: (context, index) {
            final area = areas[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: Text(
                  area.areaName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AreaWiseShopListScreen(area: area),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
