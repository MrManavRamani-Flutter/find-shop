import 'package:find_shop/models/user.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopOwnerDetailScreen extends StatefulWidget {
  final User owner;

  const ShopOwnerDetailScreen({super.key, required this.owner});

  @override
  State<ShopOwnerDetailScreen> createState() => _ShopOwnerDetailScreenState();
}

class _ShopOwnerDetailScreenState extends State<ShopOwnerDetailScreen> {
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  String? _newMapAddress;

  @override
  void initState() {
    super.initState();
    _fetchShopData();
  }

  Future<void> _fetchShopData() async {
    setState(() {
      _isLoading = true;
    });
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    await shopProvider.fetchShopByUserId(widget.owner.userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final shop = shopProvider.shop;
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.owner.username),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.orangeAccent.withOpacity(0.3),
                      child: const Icon(
                        Icons.storefront,
                        size: 70,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow("Owner Name", widget.owner.username),
                          _buildDetailRow("Shop Name", shop?.shopName ?? 'N/A'),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          _buildDetailRow("Address", shop?.address ?? 'N/A'),
                          _buildDetailRow("Email", widget.owner.email),
                          _buildDetailRow("Contact", widget.owner.contact),
                          _buildDetailRow(
                              "Status", _getStatusText(widget.owner.status)),
                          const SizedBox(height: 16),
                          if (widget.owner.contact.isNotEmpty)
                            Center(
                              child: _buildCallButton(widget.owner.contact),
                            ),
                          if (shop == null) const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        label: "Approve",
                        color: Colors.green,
                        onPressed: widget.owner.status != 1
                            ? () {
                                _updateUserStatus(context, userProvider, 1);
                              }
                            : null,
                      ),
                      _buildActionButton(
                        label: "Reject",
                        color: Colors.red,
                        onPressed: widget.owner.status != 2
                            ? () {
                                _updateUserStatus(context, userProvider, 2);
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: _buildSecondaryButton(
                      label: "Update Map Address",
                      onPressed: () {
                        _showUpdateMapAddressDialog(shopProvider);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _showUpdateMapAddressDialog(ShopProvider shopProvider) async {
    _newMapAddress = null;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Map Address'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'New Map Address'),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a map address.';
                }
                return null;
              },
              onSaved: (newValue) {
                _newMapAddress = newValue;
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (_newMapAddress != null && _newMapAddress!.isNotEmpty) {
                    await shopProvider.updateShopMapAddress(
                        widget.owner.userId, _newMapAddress!);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Map address updated successfully!"),
                        ),
                      );
                    }
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton(String phoneNumber) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.call, color: Colors.white),
      label: const Text("Call", style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      onPressed: () {
        _launchPhoneCall(phoneNumber);
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: Colors.blue, width: 2),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.blue, fontSize: 16),
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 3:
        return "Pending";
      case 1:
        return "Approved";
      case 2:
        return "Rejected";
      case 0:
        return "Others";
      default:
        return "Unknown";
    }
  }

  Future<void> _updateUserStatus(
      BuildContext context, UserProvider userProvider, int newStatus) async {
    final updatedOwner = widget.owner.copyWith(status: newStatus);
    await userProvider.updateUser(updatedOwner);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == 1 ? 'User approved!' : 'User rejected!',
          ),
        ),
      );
    }
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri callLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callLaunchUri)) {
      await launchUrl(callLaunchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone call.'),
          ),
        );
      }
    }
  }
}
