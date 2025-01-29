import 'package:flutter/material.dart';
import '../models/shop_review.dart';
import '../database/shop_review_database_helper.dart';

class ShopReviewProvider with ChangeNotifier {
  List<ShopReview> _shopReviews = [];

  List<ShopReview> get shopReviews => _shopReviews;

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
