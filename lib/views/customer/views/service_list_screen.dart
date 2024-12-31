import 'package:flutter/material.dart';
import '../../../data/global_data.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service List",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,

      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: globalServices,
        builder: (context, services, child) {
          if (services.isEmpty) {
            return const Center(
              child: Text(
                "No services available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    service['name'] ?? "Unnamed Service",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${service['price'].toString()} Rs.",
                    style: const TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                  trailing: service['available'] == true
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.cancel, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
