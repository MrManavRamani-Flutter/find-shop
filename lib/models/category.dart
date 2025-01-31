class Category {
  int? catId;
  String catName;
  String catDesc;

  Category({this.catId, required this.catName, required this.catDesc});

  // Setters
  set setCatName(String name) {
    catName = name;
  }

  set setCatDesc(String desc) {
    catDesc = desc;
  }

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
