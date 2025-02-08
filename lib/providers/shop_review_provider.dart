import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import '../models/shop_review.dart';
import '../database/shop_review_database_helper.dart';

class ShopReviewProvider with ChangeNotifier {
  List<ShopReview> _shopReviews = [];
  List<ShopReview> _userReviews = [];
  int _reviewCount = 0;
  late int currentUserId;

  List<ShopReview> get shopReviews => _shopReviews;

  List<ShopReview> get userReviews => _userReviews;

  int get reviewCount => _reviewCount;

  Future<void> setCurrentUserId() async {
    currentUserId = await SharedPreferencesHelper().getUserId() ?? 0;
    notifyListeners();
  }

  Future<bool> hasReviewedShop(int shopId) async {
    await setCurrentUserId(); // Ensure user ID is loaded
    return await ShopReviewDatabaseHelper()
        .hasUserReviewedShop(currentUserId, shopId);
  }

  // Fetch the total review count for a specific shop
  Future<void> fetchShopReviewCount(int shopId) async {
    _reviewCount = await ShopReviewDatabaseHelper().getShopReviewCount(shopId);
    // print("----------\n\n$_reviewCount\n\n----------");
    notifyListeners();
  }

  Future<void> fetchShopReviewsByShopId(int shopId) async {
    final shopReviewsList =
        await ShopReviewDatabaseHelper().getShopReviewsByShopId(shopId);
    _shopReviews = shopReviewsList;
    notifyListeners();
  }

  Future<void> fetchShopReviewsByUserId(int userId) async {
    final userReviewsList =
        await ShopReviewDatabaseHelper().getShopReviewsByUserId(userId);
    _userReviews = userReviewsList;
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
