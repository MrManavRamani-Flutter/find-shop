class ShopReview {
  int? revId;
  final String comment;
  final double rating;
  final int shopId;
  final int userId;
  final String reviewDate;

  ShopReview({
    this.revId,
    required this.comment,
    required this.rating,
    required this.shopId,
    required this.userId,
    required this.reviewDate,
  });

  factory ShopReview.fromMap(Map<String, dynamic> map) {
    return ShopReview(
      revId: map['rev_id'],
      comment: map['comment'],
      rating: map['rating'],
      shopId: map['shop_id'],
      userId: map['user_id'],
      reviewDate: map['review_date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rev_id': revId,
      'comment': comment,
      'rating': rating,
      'shop_id': shopId,
      'user_id': userId,
      'review_date': reviewDate,
    };
  }
}
