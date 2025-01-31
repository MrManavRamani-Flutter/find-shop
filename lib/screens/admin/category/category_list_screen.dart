import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/models/category.dart';
import 'package:find_shop/providers/category_provider.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  CategoryListScreenState createState() => CategoryListScreenState();
}

class CategoryListScreenState extends State<CategoryListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category List', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(categoryProvider),
            const SizedBox(height: 10),
            _buildCategoryList(categoryProvider),
          ],
        ),
      ),
    );
  }

  // Search bar widget
  Widget _buildSearchBar(CategoryProvider categoryProvider) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search Category...',
        prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  categoryProvider.fetchCategories();
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (query) {
        // Add search logic if necessary
        categoryProvider.fetchCategories();
      },
    );
  }

  // Category list widget
  Widget _buildCategoryList(CategoryProvider categoryProvider) {
    return Expanded(
      child: categoryProvider.categories.isEmpty
          ? const Center(
              child: Text(
                'No Categories Found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: categoryProvider.categories.length,
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(category.catName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(category.catDesc,
                        style: const TextStyle(fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _showEditCategoryDialog(category),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _showDeleteCategoryDialog(category.catId!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Add Category Dialog
  void _showAddCategoryDialog() {
    _showCategoryDialog(
      title: 'Add New Category',
      confirmText: 'Add',
      onConfirm: (name, desc) async {
        final category = Category(catName: name, catDesc: desc);
        await Provider.of<CategoryProvider>(context, listen: false)
            .addCategory(category);
      },
    );
  }

  // Edit Category Dialog
  void _showEditCategoryDialog(Category category) {
    _showCategoryDialog(
      title: 'Edit Category',
      initialValue: category.catName,
      descriptionInitialValue: category.catDesc,
      confirmText: 'Update',
      onConfirm: (name, desc) {
        category.catName = name;
        category.catDesc = desc;
        Provider.of<CategoryProvider>(context, listen: false)
            .updateCategory(category);
      },
    );
  }

  // Delete Category Dialog
  void _showDeleteCategoryDialog(int categoryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<CategoryProvider>(context, listen: false)
                  .deleteCategory(categoryId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Generic Category Dialog (for add/edit)
  void _showCategoryDialog({
    required String title,
    String initialValue = '',
    String descriptionInitialValue = '',
    required String confirmText,
    required Function(String, String) onConfirm,
  }) {
    final nameController = TextEditingController(text: initialValue);
    final descriptionController =
        TextEditingController(text: descriptionInitialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Category Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                onConfirm(nameController.text, descriptionController.text);
                Navigator.of(context).pop();
              } else {
                _showErrorDialog(
                    'Category name and description cannot be empty.');
              }
            },
            child: Text(confirmText,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
