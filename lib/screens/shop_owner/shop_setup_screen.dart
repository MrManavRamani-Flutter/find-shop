import 'package:find_shop/models/shop.dart';
import 'package:find_shop/models/shop_category.dart';
import 'package:find_shop/providers/area_provider.dart';
import 'package:find_shop/providers/category_provider.dart';
import 'package:find_shop/providers/shop_category_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopSetupScreen extends StatefulWidget {
  const ShopSetupScreen({super.key});

  @override
  ShopSetupScreenState createState() => ShopSetupScreenState();
}

class ShopSetupScreenState extends State<ShopSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  int? _selectedAreaId;
  int? _selectedCategoryId;
  int? _userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id');
    });
  }

  Future<void> _saveShop() async {
    if (!_formKey.currentState!.validate() ||
        _selectedAreaId == null ||
        _selectedCategoryId == null ||
        _userId == null) {
      return;
    }

    setState(() => _isLoading = true);

    final newShop = Shop(
      shopName: _shopNameController.text,
      address: _addressController.text,
      areaId: _selectedAreaId!,
      userId: _userId!,
      createdAt: DateTime.now().toIso8601String(),
    );

    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    int shopId = await shopProvider.addShop(newShop);

    if (mounted) {
      final shopCategoryProvider =
          Provider.of<ShopCategoryProvider>(context, listen: false);
      await shopCategoryProvider.addShopCategory(
        ShopCategory(shopId: shopId, catId: _selectedCategoryId!),
      );
    }
    await SharedPreferencesHelper().updateUserStatus(3);

    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop added successfully!')),
      );
    }
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/shop_home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final areas = Provider.of<AreaProvider>(context).areas;
    final categories = Provider.of<CategoryProvider>(context).categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Shop Profile Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _shopNameController,
                decoration: const InputDecoration(labelText: 'Shop Name'),
                validator: (value) => value!.isEmpty ? 'Enter shop name' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Enter address' : null,
              ),
              DropdownButtonFormField<int>(
                value: _selectedAreaId,
                decoration: const InputDecoration(labelText: 'Select Area'),
                items: areas.map((area) {
                  return DropdownMenuItem<int>(
                    value: area.areaId,
                    child: Text(area.areaName),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedAreaId = value),
                validator: (value) => value == null ? 'Select an area' : null,
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Select Category'),
                items: categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.catId,
                    child: Text(category.catName),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategoryId = value),
                validator: (value) =>
                    value == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _saveShop,
                  child: const Text('Save Shop'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
