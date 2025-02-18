import 'package:find_shop/screens/customer/category_screens/customer_category_shop_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/providers/category_provider.dart';
import 'package:find_shop/models/category.dart';

class CustomerCategoryListScreen extends StatefulWidget {
  const CustomerCategoryListScreen({super.key});

  @override
  State<CustomerCategoryListScreen> createState() =>
      _CustomerCategoryListScreenState();
}

class _CustomerCategoryListScreenState
    extends State<CustomerCategoryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
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
          'Categories',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildCategoryList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Category...',
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

  Widget _buildCategoryList() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        List<Category> filteredCategories = categoryProvider.categories
            .where((category) =>
                category.catName.toLowerCase().contains(_searchQuery))
            .toList();

        if (filteredCategories.isEmpty) {
          return const Center(
            child: Text(
              'No categories found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            final category = filteredCategories[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.category, color: Colors.blueAccent),
                title: Text(category.catName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(category.catDesc,
                    style: const TextStyle(color: Colors.grey)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerCategoryShopListScreen(
                        selectedCategory: category,
                      ),
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
