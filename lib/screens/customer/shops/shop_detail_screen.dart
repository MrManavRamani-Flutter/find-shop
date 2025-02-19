import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:find_shop/providers/favorite_shop_provider.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:find_shop/providers/shop_category_provider.dart';
import 'package:find_shop/providers/category_provider.dart';
import 'package:find_shop/providers/area_provider.dart';
import 'package:find_shop/providers/shop_review_provider.dart';
import 'package:find_shop/models/shop.dart';
import 'package:find_shop/models/user.dart';
import 'package:find_shop/models/category.dart';
import 'package:find_shop/models/area.dart';
import 'package:find_shop/models/shop_review.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerShopDetailScreen extends StatefulWidget {
  final int shopId;
  final int shopUserId;

  const CustomerShopDetailScreen({
    super.key, // Added Key?
    required this.shopId,
    required this.shopUserId,
  });

  @override
  CustomerShopDetailScreenState createState() =>
      CustomerShopDetailScreenState();
}

class CustomerShopDetailScreenState extends State<CustomerShopDetailScreen> {
  late ShopProvider _shopProvider;
  late UserProvider _userProvider;
  late ShopCategoryProvider _shopCategoryProvider;
  late CategoryProvider _categoryProvider;
  late AreaProvider _areaProvider;
  late FavoriteShopProvider _favoriteShopProvider;
  late ShopReviewProvider _shopReviewProvider;

  bool _isLoading = true;
  Shop? _shop;
  User? _user;
  Category? _category;
  Area? _area;
  bool _isFavorite = false;
  bool _isReviewAvailable = true;

  @override
  void initState() {
    super.initState();
    _favoriteShopProvider =
        Provider.of<FavoriteShopProvider>(context, listen: false);
    _shopReviewProvider =
        Provider.of<ShopReviewProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    _shopProvider = Provider.of<ShopProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _shopCategoryProvider =
        Provider.of<ShopCategoryProvider>(context, listen: false);
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _areaProvider = Provider.of<AreaProvider>(context, listen: false);

    try {
      await Future.wait([
        _shopProvider.fetchShopByUserId(widget.shopUserId),
        _userProvider.fetchUsers(),
        _categoryProvider.fetchCategories(),
        _shopCategoryProvider.fetchCategoriesForShop(widget.shopId),
        _areaProvider.fetchAreas(),
        _shopReviewProvider.fetchShopReviewsByShopId(widget.shopId),
      ]);
    } catch (e) {
      // Handle any errors that might occur during data fetching.
      debugPrint('Error fetching data: $e'); // Log the error for debugging.
      if (mounted) {
        // Check if the widget is still mounted.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load shop details.')),
        );
      }
      setState(() {
        _isLoading = false; // Stop the loading indicator.
      });
      return; // Exit the function if there's an error.
    }

    setState(() {
      _shop = _shopProvider.shop;
      _user = _userProvider.getUserByUserId(widget.shopUserId);

      SharedPreferencesHelper().getUserId().then((userId) {
        _shopReviewProvider.hasReviewedShop(widget.shopId).then((hasReviewed) {
          setState(() {
            _isReviewAvailable = !hasReviewed;
          });
        });
      });

      if (_shop != null) {
        try {
          var shopCategory = _shopCategoryProvider.shopCategories.firstWhere(
            (sc) => sc.shopId == _shop!.shopId,
          );
          _category = _categoryProvider.categories.firstWhere(
            (c) => c.catId == shopCategory.catId,
          );
          _area = _areaProvider.areas.firstWhere(
            (a) => a.areaId == _shop!.areaId,
          );
        } catch (e) {
          // Handle the case where related data is not found.
          debugPrint('Error finding related data: $e');
          // You might want to set _category or _area to a default value or show an error message.
        }
      }

      _favoriteShopProvider.isFavorite(widget.shopId).then((value) {
        setState(() {
          _isFavorite = value;
        });
      });

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        // Changed to a more modern blue
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () async {
              await _favoriteShopProvider.toggleFavoriteShop(widget.shopId);
              final message =
                  _isFavorite ? 'Removed from favorites' : 'Added to favorites';
              setState(() {
                _isFavorite = !_isFavorite;
              });
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: const Duration(
                        milliseconds:
                            1500), // Added a duration to the snackbar.
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _shop == null || _shop!.shopId == -1
              ? const Center(child: Text('Shop details not available'))
              : _buildShopProfile(),
    );
  }

  Widget _buildShopProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Changed to start.
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _user != null ? _buildOwnerInfo(_user!) : Container(),
          const SizedBox(height: 20),
          _buildShopDetails(),
          const SizedBox(height: 20),
          _buildShopReviews(),
          const SizedBox(height: 20),
          _buildContactButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      // Center the header content.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 60, // Increased the radius for a larger avatar.
            backgroundColor: Colors.grey[300], // Slightly lighter grey.
            child: const Icon(Icons.store,
                size: 60, color: Colors.blue), // Increased icon size.
          ),
          const SizedBox(height: 12), // Reduced space.
          Text(
            _shop!.shopName ?? 'No Name',
            style: const TextStyle(
              fontSize: 28, // Increased font size.
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Slightly darker text.
            ),
            textAlign: TextAlign.center, // Center-align the text.
          ),
          const SizedBox(height: 8), // Reduced space.
          Text(
            _category != null ? _category!.catName : "No Category",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center, // Center-align the text.
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfo(User user) {
    return Card(
      elevation: 4, // Increased elevation for a stronger shadow.
      margin: const EdgeInsets.symmetric(horizontal: 8), // Added margin.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners.
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Owner Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600, // Semi-bold.
                color: Colors.blue[800], // A deeper blue for the title.
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.person, 'Name', user.username),
            _buildInfoRow(Icons.email, 'Email', user.email),
            _buildInfoRow(Icons.phone, 'Contact', user.contact),
          ],
        ),
      ),
    );
  }

  Widget _buildShopDetails() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8), // Added margin.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shop Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600, // Semi-bold.
                color: Colors.blue[800], // A deeper blue.
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on,
              'Address',
              _shop!.address ?? 'No Address',
            ),
            _buildInfoRow(
              Icons.map,
              'Area',
              _area?.areaName ?? 'No Area',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopReviews() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8), // Added margin.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600, // Semi-bold.
                color: Colors.blue[800], // A deeper blue.
              ),
            ),
            const SizedBox(height: 12),
            if (_shopReviewProvider.shopReviews.isNotEmpty)
              ..._shopReviewProvider.shopReviews.map((review) {
                return _buildReviewCard(review);
              })
            else
              const Center(
                child: Text(
                  'No reviews yet. Be the first to leave a review!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            _buildAddReviewButton(),
          ],
        ),
      ),
    );
  }

  // Widget _buildSectionTitle(String title) {
  //   return Text(
  //     title,
  //     style: const TextStyle(
  //       fontSize: 18,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Increased spacing.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blue, // Changed to a more consistent blue.
            size: 24, // Increased icon size.
          ),
          const SizedBox(width: 16), // Increased spacing.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey, // Subtle color.
                  ),
                ),
                const SizedBox(height: 4), // Reduced space.
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87, // Darker text.
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ShopReview review) {
    final reviewer = _userProvider.getUserByUserId(review.userId);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16.0), // Increased padding.
      decoration: BoxDecoration(
        color: Colors.blue[50], // Lighter shade of blue.
        borderRadius: BorderRadius.circular(16), // More rounded corners.
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Subtle shadow.
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/logo/user.png'),
              ),
              const SizedBox(width: 12),
              Text(
                reviewer.username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87, // Darker text.
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RatingBarIndicator(
            rating: review.rating,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20,
            direction: Axis.horizontal,
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddReviewButton() {
    return ElevatedButton(
      onPressed: () {
        if (_isReviewAvailable) {
          Navigator.pushNamed(context, '/customer_add_review',
                  arguments: widget.shopId)
              .then((value) => _fetchData());
        } else {
          // Optionally, display a message that the user has already reviewed.
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('You have already reviewed this shop.')),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        // Changed to a more modern blue.
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      child: Text(
        _isReviewAvailable ? 'Add Review' : 'Review Added',
        // Dynamically display button text
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContactButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // Added horizontal padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            // Use Expanded to make buttons take equal width.
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  _launchPhoneCall(_user?.contact ?? '');
                },
                icon: const Icon(Icons.call, color: Colors.white),
                label: const Text('Call',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  // Consistent padding.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  // Subtle elevation.
                  shadowColor: Colors.black26, // Subtle shadow.
                ),
              ),
            ),
          ),
          (_shop!.mapAddress == null)
              ? const SizedBox()
              : Expanded(
                  // Use Expanded to make buttons take equal width.
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _launchMap(
                            _shop?.mapAddress ?? ''); // Use the shop's address.
                      },
                      icon: const Icon(Icons.map, color: Colors.white),
                      label: const Text('Map',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        // Consistent padding.
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: Colors.black26,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Helper function to launch the phone call
  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone call'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      }
    }
  }

  // Helper function to launch the map
  Future<void> _launchMap(String address) async {
    final Uri googleMapsUrl = Uri.parse(address);
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }
}
