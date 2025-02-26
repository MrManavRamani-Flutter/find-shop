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
    super.key,
    required this.shopId,
    required this.shopUserId,
  });

  @override
  CustomerShopDetailScreenState createState() =>
      CustomerShopDetailScreenState();
}

class CustomerShopDetailScreenState extends State<CustomerShopDetailScreen> {
  ShopProvider? _shopProvider;
  UserProvider? _userProvider;
  ShopCategoryProvider? _shopCategoryProvider;
  CategoryProvider? _categoryProvider;
  AreaProvider? _areaProvider;
  FavoriteShopProvider? _favoriteShopProvider;
  ShopReviewProvider? _shopReviewProvider;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  Future<void> _fetchData() async {
    // Initialize providers
    _shopProvider = Provider.of<ShopProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _shopCategoryProvider =
        Provider.of<ShopCategoryProvider>(context, listen: false);
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _areaProvider = Provider.of<AreaProvider>(context, listen: false);
    _favoriteShopProvider =
        Provider.of<FavoriteShopProvider>(context, listen: false);
    _shopReviewProvider =
        Provider.of<ShopReviewProvider>(context, listen: false);

    // Fetch data
    try {
      await Future.wait([
        _shopProvider!.fetchShopByUserId(widget.shopUserId),
        _userProvider!.fetchUsers(),
        _shopCategoryProvider!.fetchCategoriesForShop(widget.shopId),
        _categoryProvider!.fetchCategories(),
        _areaProvider!.fetchAreas(),
        _shopReviewProvider!.fetchShopReviewsByShopId(widget.shopId),
      ]);
    } catch (e) {
      debugPrint('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load shop details.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Store fetched data
    setState(() {
      _shop = _shopProvider!.shop;
      _user = _userProvider!.getUserByUserId(widget.shopUserId);
      _category = _categoryProvider!.categories.firstWhere(
        (c) =>
            c.catId ==
            _shopCategoryProvider!.shopCategories
                .firstWhere(
                  (sc) => sc.shopId == _shop!.shopId,
                )
                .catId,
      );

      _area = _areaProvider!.areas.firstWhere(
        (a) => a.areaId == _shop!.areaId,
        orElse: () => Area(areaId: -1, areaName: 'N/A'), // Fallback area
      );

      SharedPreferencesHelper().getUserId().then((userId) {
        _shopReviewProvider!.hasReviewedShop(widget.shopId).then((hasReviewed) {
          setState(() {
            _isReviewAvailable = !hasReviewed;
          });
        });
      });

      _favoriteShopProvider!.isFavorite(widget.shopId).then((value) {
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
        title: Text(
          _shop?.shopName ?? 'Loading...', // Fallback if shop is not yet loaded
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () async {
              await _favoriteShopProvider!.toggleFavoriteShop(widget.shopId);
              final message =
                  _isFavorite ? 'Removed from favorites' : 'Added to favorites';
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(message),
                    duration: const Duration(milliseconds: 1500)),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _shop == null
              ? const Center(child: Text('Shop details not available'))
              : _buildShopProfile(),
    );
  }

  Widget _buildShopProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.store, size: 60, color: Colors.blue),
          ),
          const SizedBox(height: 12),
          Text(
            _shop?.shopName ?? 'No Name',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _category?.catName ?? "No Category",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfo(User user) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Owner Information',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shop Details',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on,
              'Address',
              _shop?.address ?? 'No Address',
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            ),
            const SizedBox(height: 12),
            if (_shopReviewProvider!.shopReviews.isNotEmpty)
              ..._shopReviewProvider!.shopReviews.map((review) {
                return _buildReviewCard(review);
              })
            else
              const Center(
                child: Text(
                  'No reviews yet. Be the first to leave a review!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 12),
            _buildAddReviewButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ShopReview review) {
    final reviewer = _userProvider!.getUserByUserId(review.userId);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
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
                    color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RatingBarIndicator(
            rating: review.rating.toDouble(),
            itemBuilder: (context, index) =>
                const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 20,
            direction: Axis.horizontal,
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('You have already reviewed this shop.')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      child: Text(
        _isReviewAvailable ? 'Add Review' : 'Review Added',
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildContactButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ),
          if (_shop?.mapAddress != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _launchMap(_shop!.mapAddress!);
                  },
                  icon: const Icon(Icons.map, color: Colors.white),
                  label: const Text('Map',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Launch phone call
  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Could not launch phone call'),
            duration: Duration(milliseconds: 1500)),
      );
    }
  }

  // Launch map
  Future<void> _launchMap(String address) async {
    final Uri googleMapsUrl = Uri.parse(address);
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }
}
