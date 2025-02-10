import 'package:find_shop/providers/upload_provider/upload_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadDataScreen extends StatelessWidget {
  const UploadDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uploadProvider = Provider.of<UploadProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Admin Data Upload",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Upload Excel Files",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            // Use Card or Container for better styling
            _buildUploadCard(
              context,
              uploadProvider,
              'areas',
              Icons.map,
              'Upload Areas',
              Colors.blueAccent,
            ),
            const SizedBox(height: 15),
            _buildUploadCard(
              context,
              uploadProvider,
              'categories',
              Icons.category,
              'Upload Categories',
              Colors.orange.shade700,
            ),
            const SizedBox(height: 30),
            // Show progress if loading
            if (uploadProvider.isLoading)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            if (uploadProvider.isLoading) const SizedBox(height: 20),
            if (uploadProvider.isLoading)
              const Text(
                "Please wait, uploading...",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard(
    BuildContext context,
    UploadProvider uploadProvider,
    String tableName,
    IconData icon,
    String label,
    Color color,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          onTap: () => uploadProvider.uploadExcelFile(context, tableName),
          contentPadding: const EdgeInsets.all(10.0),
          leading: Icon(icon, size: 32, color: color),
          title: Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          tileColor: color.withOpacity(0.1),
          trailing: const Icon(Icons.arrow_forward, color: Colors.grey),
        ),
      ),
    );
  }
}
