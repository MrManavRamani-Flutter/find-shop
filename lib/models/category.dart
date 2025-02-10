class Category {
  int? catId;
  String catName;
  String catDesc;

  Category({this.catId, required this.catName, required this.catDesc});

  // Setter for catId
  set setCatId(int id) {
    catId = id;
  }

  // Setter for catName
  set setCatName(String name) {
    catName = name;
  }

  // Setter for catDesc
  set setCatDesc(String desc) {
    catDesc = desc;
  }

  // Getter for catId (optional)
  int? get getCatId => catId;

  // Getter for catName
  String get getCatName => catName;

  // Getter for catDesc
  String get getCatDesc => catDesc;

  // Factory constructor to create a Category object from a map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      catId: map['cat_id'], // Assigning catId from map
      catName: map['cat_name'], // Assigning catName from map
      catDesc: map['cat_desc'], // Assigning catDesc from map
    );
  }

  // Convert Category object to a map
  Map<String, dynamic> toMap() {
    return {
      'cat_id': catId, // Mapping catId to map
      'cat_name': catName, // Mapping catName to map
      'cat_desc': catDesc, // Mapping catDesc to map
    };
  }
}
