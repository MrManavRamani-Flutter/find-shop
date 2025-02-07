import 'package:find_shop/models/shop_review.dart';
import 'package:find_shop/providers/shop_provider.dart';
import 'package:find_shop/providers/shop_review_provider.dart';
import 'package:find_shop/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopReviewListScreen extends StatefulWidget {
  const ShopReviewListScreen({super.key});

  @override
  State<ShopReviewListScreen> createState() => _ShopReviewListScreenState();
}

class _ShopReviewListScreenState extends State<ShopReviewListScreen>
    with SingleTickerProviderStateMixin {
  int? shopId;
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final shopProvider = Provider.of<ShopProvider>(context, listen: false);
      final shopReviewProvider =
          Provider.of<ShopReviewProvider>(context, listen: false);

      await userProvider.fetchLoggedInUser();
      final loggedInUser = userProvider.loggedInUser;

      if (loggedInUser != null) {
        await shopProvider.fetchShopByUserId(loggedInUser.userId);
        if (shopProvider.shop != null) {
          shopId = shopProvider.shop!.shopId;
          await shopReviewProvider.fetchShopReviewsByShopId(shopId!);
        }
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<ShopReview> _filterReviews(
      List<ShopReview> reviews, double minRating, double maxRating) {
    return reviews
        .where((review) =>
            review.rating >= minRating && review.rating <= maxRating)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop Reviews',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          controller: _tabController,
          tabs: const [
            Tab(text: "1.0 ⭐"),
            Tab(text: "2.0 ⭐"),
            Tab(text: "3.0 ⭐"),
            Tab(text: "4.0 ⭐"),
            Tab(text: "5.0 ⭐"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<ShopReviewProvider>(
              builder: (context, reviewProvider, child) {
                final reviews = reviewProvider.shopReviews;
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReviewList(_filterReviews(reviews, 1.0, 1.9)),
                    _buildReviewList(_filterReviews(reviews, 2.0, 2.9)),
                    _buildReviewList(_filterReviews(reviews, 3.0, 3.9)),
                    _buildReviewList(_filterReviews(reviews, 4.0, 4.9)),
                    _buildReviewList(_filterReviews(reviews, 5.0, 5.0)),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildReviewList(List<ShopReview> reviews) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (reviews.isEmpty) {
      return const Center(child: Text('No reviews available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        final user =
            userProvider.getUserByUserId(review.userId); // Fetch user by ID
        final username = user.username;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Row
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/logo/user.png'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(
                            review.rating.floor(),
                            (index) => const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                          ) +
                          List.generate(
                            5 - review.rating.floor(),
                            (index) => const Icon(Icons.star_border,
                                color: Colors.grey, size: 18),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Review Comment
                Text(
                  review.comment,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.5, // Better line spacing
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
