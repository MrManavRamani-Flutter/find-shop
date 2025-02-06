import 'package:find_shop/models/shop_review.dart';
import 'package:find_shop/providers/shop_review_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class CustomerAddReviewScreen extends StatefulWidget {
  final int shopId;

  const CustomerAddReviewScreen({super.key, required this.shopId});

  @override
  CustomerAddReviewScreenState createState() => CustomerAddReviewScreenState();
}

class CustomerAddReviewScreenState extends State<CustomerAddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 0;
  String _comment = '';
  late int _userId;
  late FocusNode _commentFocusNode;

  @override
  void initState() {
    super.initState();
    _commentFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  // Function to handle the submission of the review
  void _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final shopReview = ShopReview(
        comment: _comment,
        rating: _rating,
        shopId: widget.shopId,
        userId: _userId,
        reviewDate: DateTime.now().toIso8601String(),
      );

      await Provider.of<ShopReviewProvider>(context, listen: false)
          .addShopReview(shopReview);

      // After adding the review, navigate back to the previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
      ),
      body: FutureBuilder<void>(
        future: Provider.of<ShopReviewProvider>(context, listen: false)
            .setCurrentUserId(), // Ensure user ID is fetched
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle errors in setting user ID
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Now we can safely access _userId
          _userId = Provider.of<ShopReviewProvider>(context).currentUserId;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Rating Input
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Comment Input (ensure comment state is retained)
                  TextFormField(
                    focusNode: _commentFocusNode,
                    initialValue: _comment,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Your Comment',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a comment';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _comment = value; // Update the comment without setState

                      // Remove focus when the user types the first letter
                      if (_comment.isNotEmpty && !_commentFocusNode.hasFocus) {
                        _commentFocusNode.unfocus(); // Remove focus
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
