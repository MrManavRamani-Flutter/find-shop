import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import '../models/shop_review.dart';
import '../database/shop_review_database_helper.dart';

class ShopReviewProvider with ChangeNotifier {
  List<ShopReview> _shopReviews = [];
  late int currentUserId; // To hold the current logged-in user's ID

  List<ShopReview> get shopReviews => _shopReviews;

  // Fetch current logged-in user ID using SharedPreferences
  Future<void> setCurrentUserId() async {
    currentUserId = await SharedPreferencesHelper().getUserId() ?? 0;
    notifyListeners();
  }

  Future<bool> hasReviewedShop(int shopId) async {
    // Retrieve all reviews for the given shop ID
    final shopReviewsList =
        await ShopReviewDatabaseHelper().getShopReviewsByShopId(shopId);

    // Check if the current user has already reviewed the shop
    return shopReviewsList.any((review) => review.userId == currentUserId);
  }

  Future<void> fetchShopReviewsByShopId(int shopId) async {
    final shopReviewsList =
        await ShopReviewDatabaseHelper().getShopReviewsByShopId(shopId);
    _shopReviews = shopReviewsList;
    notifyListeners();
  }

  Future<void> fetchShopReviews() async {
    final shopReviewsList = await ShopReviewDatabaseHelper().getShopReviews();
    _shopReviews = shopReviewsList;
    notifyListeners();
  }

  Future<void> addShopReview(ShopReview shopReview) async {
    await ShopReviewDatabaseHelper().insertShopReview(shopReview);
    await fetchShopReviews();
  }

  Future<void> updateShopReview(ShopReview shopReview) async {
    await ShopReviewDatabaseHelper().updateShopReview(shopReview);
    await fetchShopReviews();
  }

  Future<void> deleteShopReview(int revId) async {
    await ShopReviewDatabaseHelper().deleteShopReview(revId);
    await fetchShopReviews();
  }
}
