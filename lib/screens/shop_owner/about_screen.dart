import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutShopScreen extends StatelessWidget {
  const AboutShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/shop_home');
          },
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        elevation: 3, // Add a subtle shadow
      ),
      body: SingleChildScrollView(
        // For scrolling on smaller screens
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align text to the left
            children: [
              // App Introduction - Enhanced Styling
              const Text(
                'Welcome to Find Shop',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Find Shop is a mobile application designed to connect users with local businesses, helping them discover products and services with ease.',
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5, // Improved line spacing
                ),
                textAlign: TextAlign.justify, // Justified text
              ),
              const SizedBox(height: 30),

              // Mission Statement
              const Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'To empower local entrepreneurs and businesses by providing a user-friendly platform to showcase their offerings and connect with a wider audience, fostering community growth and supporting local economies.',
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 40),

              // Contact Section - Modern Design
              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  // Subtle background
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    _buildContactRow(Icons.person, 'Name', 'Manav Ramani'),
                    const Divider(height: 15, color: Colors.grey),
                    _buildContactRow(
                        Icons.email, 'Email', 'manavramani3402003@gmail.com'),
                    const Divider(height: 15, color: Colors.grey),
                    _buildContactRow(Icons.phone, 'Contact', '+91 7096584269'),
                    // Include country code
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Call and Email Buttons - Modern Style
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Distribute space
                children: [
                  _buildElevatedButton(
                    'Call',
                    Icons.call,
                    () => launchUrl(
                        Uri.parse('tel:+917096584269')), // Country code
                  ),
                  _buildElevatedButton(
                    'Email',
                    Icons.email,
                    () => launchUrl(
                        Uri.parse('mailto:manavramani3402003@gmail.com')),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build contact rows
  Widget _buildContactRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent), // Use the same color scheme
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)), // Bolder subtitle
          ],
        ),
      ],
    );
  }

  // Helper function to build the styled buttons
  Widget _buildElevatedButton(
      String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: Colors.white),
      label:
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3, // subtle shadow
      ),
    );
  }
}
