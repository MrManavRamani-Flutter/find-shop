class ShopReview {
  int? reviewId;
  double rating;
  String? review;
  int shopId;
  int userId;
  String createdAt;

  ShopReview({
    this.reviewId,
    required this.rating,
    this.review,
    required this.shopId,
    required this.userId,
    required this.createdAt,
  });

  // Convert a ShopReview object into a map (for storing into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'review_id': reviewId,
      'rating': rating,
      'review': review,
      'shop_id': shopId,
      'user_id': userId,
      'created_at': createdAt,
    };
  }

  // Convert a map into a ShopReview object (for reading from SQLite)
  factory ShopReview.fromMap(Map<String, dynamic> map) {
    return ShopReview(
      reviewId: map['review_id'],
      rating: map['rating'],
      review: map['review'],
      shopId: map['shop_id'],
      userId: map['user_id'],
      createdAt: map['created_at'],
    );
  }
}
