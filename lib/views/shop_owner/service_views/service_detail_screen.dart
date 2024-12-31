import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          service["name"] ?? "Service Details",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Service Name
            Text(
              service["name"] ?? "Service Name",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Service Description
            Text(
              service["description"] ?? "Service Description",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            // Price
            Text(
              "Price: \$${service["price"] ?? "N/A"}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Availability
            Row(
              children: [
                const Text("Available: "),
                Icon(
                  service["available"] ?? false
                      ? Icons.check_circle
                      : Icons.cancel,
                  color:
                      service["available"] ?? false ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Shop Details
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              "Shop Details:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Shop Name: ${service["shopName"] ?? "N/A"}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Address: ${service["address"] ?? "N/A"}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Contact: ${service["contact"] ?? "N/A"}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Button to Book or Request the Service
            ElevatedButton(
              onPressed: () {
                // Action to request the service or book it
                // Add your functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "Service Remove",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
