import 'package:find_shop/views/login_screen.dart';

import 'views/customer_profile_screen.dart';
import 'views/product_list_screen.dart';
import 'package:flutter/material.dart';

import 'views/shop_list_screen.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Shop",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.teal.shade800),
              accountName: const Text(
                "John Doe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text(
                "john.doe@example.com",
                style: TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.teal.shade300,
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.teal),
              title: const Text("Home"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.teal),
              title: const Text("Shop"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.teal),
              title: const Text("Products"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.design_services, color: Colors.teal),
              title: const Text("Services"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Service Page Coming Soon!!"),
                    duration: Duration(seconds: 1),
                  ),
                );
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const ServiceListScreen(),
                //   ),
                // );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category, color: Colors.teal),
              title: const Text("Categories"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Category Page Coming Soon!!"),
                    duration: Duration(seconds: 1),
                  ),
                );
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const CategoryListScreen(),
                //   ),
                // );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.teal),
              title: const Text("Favorites"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Favorite Page Coming Soon!!"),
                    duration: Duration(seconds: 1),
                  ),
                );
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/favorites');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.teal),
              title: const Text("Settings"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Setting Page Coming Soon!!"),
                    duration: Duration(seconds: 1),
                  ),
                );
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/settings');
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal),
              title: const Text("Logout"),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),

      // drawer: Drawer(
      //   child: Column(
      //     children: [
      //       DrawerHeader(
      //         decoration: BoxDecoration(color: Colors.teal.shade800),
      //         child: const Center(
      //           child: Text(
      //             "Customer Menu",
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 20,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.home, color: Colors.teal),
      //         title: const Text("Home"),
      //         onTap: () {
      //           Navigator.pop(context); // Navigate to Home
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.category, color: Colors.teal),
      //         title: const Text("Categories"),
      //         onTap: () {
      //           Navigator.pop(context); // Navigate to Categories
      //         },
      //       ),
      //       // ListTile(
      //       //   leading: const Icon(Icons.shopping_bag, color: Colors.teal),
      //       //   title: const Text("My Orders"),
      //       //   onTap: () {
      //       //     Navigator.pop(context); // Navigate to Orders
      //       //   },
      //       // ),
      //       ListTile(
      //         leading: const Icon(Icons.settings, color: Colors.teal),
      //         title: const Text("Settings"),
      //         onTap: () {
      //           Navigator.pop(context); // Navigate to Settings
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New Shop Openings Section
              const Text(
                "New Shop Openings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Replace with dynamic data count
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.store,
                              size: 40, color: Colors.teal.shade600),
                          const SizedBox(height: 5),
                          Text(
                            "Shop ${index + 1}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Categories Section
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 6,
                // Replace with dynamic data count
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  // Replace category names with actual data
                  final categories = [
                    "Electronics",
                    "Clothing",
                    "Food",
                    "Medical",
                    "Services",
                    "Others",
                  ];
                  final categoryIcons = [
                    Icons.electrical_services,
                    Icons.checkroom,
                    Icons.fastfood,
                    Icons.local_hospital,
                    Icons.design_services,
                    Icons.category,
                  ];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(categoryIcons[index],
                            size: 40, color: Colors.teal),
                        const SizedBox(height: 5),
                        Text(
                          categories[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
