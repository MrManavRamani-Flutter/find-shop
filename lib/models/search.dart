class Search {
  final int searchId;
  final String query;
  final int userId;
  final String searchedAt;

  Search({
    required this.searchId,
    required this.query,
    required this.userId,
    required this.searchedAt,
  });

  factory Search.fromMap(Map<String, dynamic> map) {
    return Search(
      searchId: map['search_id'],
      query: map['query'],
      userId: map['user_id'],
      searchedAt: map['searched_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'search_id': searchId,
      'query': query,
      'user_id': userId,
      'searched_at': searchedAt,
    };
  }
}
