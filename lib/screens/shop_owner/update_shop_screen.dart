import 'package:find_shop/models/area.dart';
import 'package:find_shop/models/category.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/models/shop_category.dart';
import 'package:find_shop/providers/shop_category_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateShopScreen extends StatefulWidget {
  final Shop shop;
  final List<Area> areas;
  final ShopCategory
      shopCategory; // This represents the current shop-category relation
  final List<Category> categories;

  const UpdateShopScreen({
    super.key,
    required this.shop,
    required this.areas,
    required this.shopCategory,
    required this.categories,
  });

  @override
  UpdateShopScreenState createState() => UpdateShopScreenState();
}

class UpdateShopScreenState extends State<UpdateShopScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _shopNameController;
  late TextEditingController _addressController;
  late Area _selectedArea;
  late Category _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing shop data
    _shopNameController = TextEditingController(text: widget.shop.shopName);
    _addressController = TextEditingController(text: widget.shop.address);
    _selectedArea = widget.areas.firstWhere(
      (area) => area.areaId == widget.shop.areaId,
      orElse: () => widget.areas.first,
    );
    _selectedCategory = widget.categories.firstWhere(
      (category) => category.catId == widget.shopCategory.catId,
      orElse: () => widget.categories.first,
    );
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('Update Shop'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _shopNameController,
                decoration: const InputDecoration(labelText: 'Shop Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter shop name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Area>(
                value: _selectedArea,
                decoration: const InputDecoration(labelText: 'Area'),
                items: widget.areas
                    .map((area) => DropdownMenuItem(
                          value: area,
                          child: Text(area.areaName),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedArea = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an area';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: widget.categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.catName),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Update shop data
                    widget.shop.shopName = _shopNameController.text;
                    widget.shop.address = _addressController.text;
                    widget.shop.areaId = _selectedArea.areaId;

                    // Update ShopCategory data with the new category ID
                    widget.shopCategory.catId = _selectedCategory.catId!;

                    // Use the ShopCategoryProvider to update the ShopCategory table
                    Provider.of<ShopCategoryProvider>(context, listen: false)
                        .updateShopCategory(widget.shopCategory);

                    // Call the ShopProvider to update the shop details
                    Provider.of<ShopProvider>(context, listen: false)
                        .updateShop(widget.shop);

                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
