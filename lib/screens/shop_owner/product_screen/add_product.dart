import 'package:find_shop/models/product.dart';
import 'package:find_shop/providers/product_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  final Product? product; // Accept a product for editing (nullable)

  const AddProduct({super.key, this.product});

  @override
  AddProductState createState() => AddProductState();
}

class AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String _proName = '';
  String _proDesc = '';
  double _price = 0.0;
  int? _shopId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShopId();

    if (widget.product != null) {
      _proName = widget.product!.proName;
      _proDesc = widget.product!.proDesc;
      _price = widget.product!.price;
    }
  }

  Future<void> _fetchShopId() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);

    await userProvider.fetchLoggedInUser();
    final loggedInUser = userProvider.loggedInUser;

    if (loggedInUser != null) {
      await shopProvider.fetchShopByUserId(loggedInUser.userId);
      if (shopProvider.shop != null) {
        setState(() {
          _shopId = shopProvider.shop!.shopId;
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_shopId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shop not found for the user!')),
        );
        return;
      }

      final newProduct = Product(
        proId: widget.product?.proId,
        // If editing, use existing product ID
        proName: _proName,
        proDesc: _proDesc,
        price: _price,
        shopId: _shopId!,
      );

      if (widget.product == null) {
        // Add new product if no product passed
        Provider.of<ProductProvider>(context, listen: false)
            .addProduct(newProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product Added Successfully!')),
        );
      } else {
        // Update existing product if a product is passed
        Provider.of<ProductProvider>(context, listen: false)
            .updateProduct(newProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product Updated Successfully!')),
        );
      }

      _formKey.currentState!.reset();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Add Product' : 'Edit Product',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _proName,
                      decoration:
                          const InputDecoration(labelText: 'Product Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _proName = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: _proDesc,
                      decoration: const InputDecoration(
                          labelText: 'Product Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _proDesc = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: _price.toString(),
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _price = double.parse(value!);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(widget.product == null
                          ? 'Add Product'
                          : 'Update Product'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
