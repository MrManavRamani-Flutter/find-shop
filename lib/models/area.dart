class Area {
  int? areaId;
  String areaName;

  Area({this.areaId, required this.areaName});

  // Setter for areaId
  set setAreaId(int id) {
    areaId = id;
  }

  // Setter for areaName
  set setAreaName(String name) {
    areaName = name;
  }

  // Getter for areaId (optional)
  int? get getAreaId => areaId;

  // Getter for areaName
  String get getAreaName => areaName;

  // Factory constructor to create an Area object from a map
  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      areaId: map['area_id'], // Assigning areaId from map
      areaName: map['area_name'], // Assigning areaName from map
    );
  }

  // Convert Area object to a map
  Map<String, dynamic> toMap() {
    return {
      'area_id': areaId, // Mapping areaId to map
      'area_name': areaName, // Mapping areaName to map
    };
  }
}
