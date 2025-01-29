class Category {
  final int catId;
  final String catName;
  final String catDesc;

  Category({required this.catId, required this.catName, required this.catDesc});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      catId: map['cat_id'],
      catName: map['cat_name'],
      catDesc: map['cat_desc'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cat_id': catId,
      'cat_name': catName,
      'cat_desc': catDesc,
    };
  }
}
