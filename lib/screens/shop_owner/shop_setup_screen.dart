import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/models/shop_category.dart';
import 'package:find_shop/providers/area_provider.dart';
import 'package:find_shop/providers/category_provider.dart';
import 'package:find_shop/providers/shop_category_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/utils/shared_preferences_helper.dart';
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
    _fetchData();
  }

  void _fetchData() async {
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    await areaProvider.fetchAreas(); // Fetch latest areas
    await categoryProvider.fetchCategories(); // Fetch latest categories
  }

  Future<void> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _userId = prefs.getInt('user_id'));
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
          ShopCategory(shopId: shopId, catId: _selectedCategoryId!));
    }

    await SharedPreferencesHelper().updateUserStatus(3);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop added successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/shop_home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final areas = Provider.of<AreaProvider>(context).areas;
    final categories = Provider.of<CategoryProvider>(context).categories;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            SharedPreferencesHelper().clearUserData();
            SharedPreferencesHelper().clearAuthToken();
            SharedPreferencesHelper().clearLoginStatus();
            await userProvider.logOut();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
        title: const Text(
          'Shop Profile Setup',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: areas.isEmpty || categories.isEmpty
            ? const Center(
                child: Text(
                  "Contact This App Admin",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(_shopNameController, 'Shop Name'),
                    const SizedBox(height: 15),
                    _buildTextField(_addressController, 'Address'),
                    const SizedBox(height: 15),
                    _buildDropdownField(
                        'Select Area',
                        _selectedAreaId,
                        areas
                            .map(
                              (area) => DropdownMenuItem(
                                value: area.areaId,
                                child: Text(area.areaName),
                              ),
                            )
                            .toList(),
                        (value) => setState(() => _selectedAreaId = value)),
                    const SizedBox(height: 15),
                    _buildDropdownField(
                        'Select Category',
                        _selectedCategoryId,
                        categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category.catId,
                                child: Text(category.catName),
                              ),
                            )
                            .toList(),
                        (value) => setState(() => _selectedCategoryId = value)),
                    const SizedBox(height: 25),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.blueAccent,
                            ),
                            onPressed: _saveShop,
                            child: const Text('Save Shop',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }

  Widget _buildDropdownField(String label, int? selectedValue,
      List<DropdownMenuItem<int>> items, ValueChanged<int?> onChanged) {
    return DropdownButtonFormField<int>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: items,
      onChanged: onChanged,
      validator: (value) => value == null ? 'Select $label' : null,
    );
  }
}
