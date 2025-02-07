import 'package:find_shop/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import '../models/shop_review.dart';
import '../database/shop_review_database_helper.dart';

class ShopReviewProvider with ChangeNotifier {
  List<ShopReview> _shopReviews = [];
  late int currentUserId;

  List<ShopReview> get shopReviews => _shopReviews;

  Future<void> setCurrentUserId() async {
    currentUserId = await SharedPreferencesHelper().getUserId() ?? 0;
    notifyListeners();
  }

  Future<bool> hasReviewedShop(int shopId) async {
    await setCurrentUserId(); // Ensure user ID is loaded
    return await ShopReviewDatabaseHelper()
        .hasUserReviewedShop(currentUserId, shopId);
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
