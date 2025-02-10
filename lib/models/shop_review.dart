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

  // Factory constructor to create a ShopReview object from a map
  factory ShopReview.fromMap(Map<String, dynamic> map) {
    return ShopReview(
      revId: map['rev_id'], // Assigning revId from map
      comment: map['comment'], // Assigning comment from map
      rating: map['rating'], // Assigning rating from map
      shopId: map['shop_id'], // Assigning shopId from map
      userId: map['user_id'], // Assigning userId from map
      reviewDate: map['review_date'], // Assigning reviewDate from map
    );
  }

  // Convert ShopReview object to a map
  Map<String, dynamic> toMap() {
    return {
      'rev_id': revId, // Mapping revId to map
      'comment': comment, // Mapping comment to map
      'rating': rating, // Mapping rating to map
      'shop_id': shopId, // Mapping shopId to map
      'user_id': userId, // Mapping userId to map
      'review_date': reviewDate, // Mapping reviewDate to map
    };
  }
}
