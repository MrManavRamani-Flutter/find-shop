import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/models/area.dart';
import 'package:find_shop/providers/area_provider.dart';

class AreaListScreen extends StatefulWidget {
  const AreaListScreen({super.key});

  @override
  AreaListScreenState createState() => AreaListScreenState();
}

class AreaListScreenState extends State<AreaListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final areaProvider = Provider.of<AreaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Area List', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAreaDialog(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(areaProvider),
            const SizedBox(height: 10),
            _buildAreaList(areaProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(AreaProvider areaProvider) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search Area...',
        prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  areaProvider.fetchAreasByQuery('');
                  setState(() {});
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (query) {
        areaProvider.fetchAreasByQuery(query);
        setState(() {});
      },
    );
  }

  Widget _buildAreaList(AreaProvider areaProvider) {
    return Expanded(
      child: areaProvider.areas.isEmpty
          ? const Center(
              child: Text(
                'No Areas Found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: areaProvider.areas.length,
              itemBuilder: (context, index) {
                final area = areaProvider.areas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text(area.areaName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showEditAreaDialog(area)),
                        IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _showDeleteAreaDialog(area.areaId)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddAreaDialog() {
    _showAreaDialog(
        title: 'Add New Area',
        confirmText: 'Add',
        onConfirm: (name) {
          final area = Area(areaName: name);
          Provider.of<AreaProvider>(context, listen: false).addArea(area);
        });
  }

  void _showEditAreaDialog(Area area) {
    _showAreaDialog(
      title: 'Edit Area',
      initialValue: area.areaName,
      confirmText: 'Update',
      onConfirm: (name) {
        Provider.of<AreaProvider>(context, listen: false)
            .updateArea(area, name);
      },
    );
  }

  void _showDeleteAreaDialog(int? areaId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Area'),
        content: const Text('Are you sure you want to delete this area?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Provider.of<AreaProvider>(context, listen: false)
                  .deleteArea(areaId!);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAreaDialog(
      {required String title,
      String initialValue = '',
      required String confirmText,
      required Function(String) onConfirm}) {
    TextEditingController areaController =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
            controller: areaController,
            decoration: const InputDecoration(labelText: 'Area Name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (areaController.text.isNotEmpty) {
                onConfirm(areaController.text);
                Navigator.of(context).pop();
              } else {
                _showErrorDialog('Area name cannot be empty.');
              }
            },
            child: Text(confirmText,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK')),
        ],
      ),
    );
  }
}
