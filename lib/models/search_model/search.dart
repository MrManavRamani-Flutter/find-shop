class Search {
  int? searchId;
  String query;
  int userId;
  String createdAt;

  Search({
    this.searchId,
    required this.query,
    required this.userId,
    required this.createdAt,
  });

  // Convert a Search object into a map (for storing into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'search_id': searchId,
      'query': query,
      'user_id': userId,
      'created_at': createdAt,
    };
  }

  // Convert a map into a Search object (for reading from SQLite)
  factory Search.fromMap(Map<String, dynamic> map) {
    return Search(
      searchId: map['search_id'],
      query: map['query'],
      userId: map['user_id'],
      createdAt: map['created_at'],
    );
  }
}
