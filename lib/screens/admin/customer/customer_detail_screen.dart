import 'package:flutter/material.dart';
import 'package:find_shop/models/user.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/providers/shop_review_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import the intl package

class CustomerDetailScreen extends StatefulWidget {
  final User user;

  const CustomerDetailScreen({super.key, required this.user});

  @override
  CustomerDetailScreenState createState() => CustomerDetailScreenState();
}

class CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;

    // Fetch reviews when the screen loads
    final shopReviewProvider =
    Provider.of<ShopReviewProvider>(context, listen: false);
    shopReviewProvider.fetchShopReviewsByUserId(_user.userId);
  }

  void _toggleBlockStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Show a confirmation dialog before toggling status
    _showStatusChangeDialog(context, userProvider);
  }

  void _showStatusChangeDialog(
      BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_user.status == 1 ? 'Block User' : 'Unblock User'),
          content: Text(
            _user.status == 1
                ? 'Are you sure you want to block this customer?'
                : 'Are you sure you want to unblock this customer?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog without making changes
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Change the status and close the dialog
                int newStatus = _user.status == 1 ? 2 : 1;
                try {
                  await userProvider.updateUserStatus(_user.userId, newStatus);

                  // Update the user status locally and notify listeners
                  setState(() {
                    _user = _user.copyWith(status: newStatus);
                  });
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Handle any errors during the status update
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating status: $e')),
                    );
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopReviewProvider = Provider.of<ShopReviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('assets/logo/user.png'),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.person, "Username", _user.username),
                    _buildDetailRow(Icons.email, "Email", _user.email),
                    _buildDetailRow(Icons.phone, "Contact", _user.contact),
                    _buildDetailRow(
                        Icons.badge, "Role ID", _user.roleId.toString()),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.verified,
                            color:
                            _user.status == 1 ? Colors.green : Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          _user.status == 1 ? "Active" : "Blocked",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _user.status == 1
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleBlockStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _user.status == 1 ? Colors.red : Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  _user.status == 1 ? "Block User" : "Unblock User",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display reviews section
            const SizedBox(height: 12),
            const Text(
              "Customer Reviews",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // List reviews if available
            Expanded(
              child: shopReviewProvider.userReviews.isEmpty
                  ? const Center(
                child: Text(
                  'No reviews available.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: shopReviewProvider.userReviews.length,
                itemBuilder: (context, index) {
                  final review = shopReviewProvider.userReviews[index];
                  final formattedDate = _formatDate(review.reviewDate); // Format the review date
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${review.rating}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review.comment,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Posted on: $formattedDate', // Display the formatted date
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 10),
          Text(
            "$title:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Method to format the date
  String _formatDate(String date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final DateTime parsedDate = DateTime.parse(date);
    return formatter.format(parsedDate);
  }
}
