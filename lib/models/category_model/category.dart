class Category {
  int? catId;
  String catName;
  String catDesc;

  Category({
    this.catId,
    required this.catName,
    required this.catDesc,
  });

  // Convert a Category object into a map (for storing into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'cat_id': catId,
      'cat_name': catName,
      'cat_desc': catDesc,
    };
  }

  // Convert a map into a Category object (for reading from SQLite)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      catId: map['cat_id'],
      catName: map['cat_name'],
      catDesc: map['cat_desc'],
    );
  }
}
