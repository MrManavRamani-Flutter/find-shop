import 'package:find_shop/data/global_data.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: globalServices,
        builder: (context, services, child) {
          if (services.isEmpty) {
            return const Center(
              child: Text('No services available'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        service['available'] ? Colors.green : Colors.red,
                    child: Icon(
                      service['available'] ? Icons.check : Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(service['name']),
                  subtitle: Text(
                    'Price: Rs. ${service['price']}\n'
                    'Available: ${service['available'] ? "Yes" : "No"}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ServiceDetailsDialog(service: service),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Example: Add a new service dynamically
      //     addService({
      //       "name": "Painting",
      //       "price": 100,
      //       "available": true,
      //     });
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class ServiceDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsDialog({required this.service, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(service['name']),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price: Rs. ${service['price']}'),
          Text('Available: ${service['available'] ? "Yes" : "No"}'),
          if (service.containsKey('shopName'))
            Text('Shop Name: ${service['shopName']}'),
          if (service.containsKey('address'))
            Text('Address: ${service['address']}'),
          if (service.containsKey('contact'))
            Text('Contact: ${service['contact']}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
