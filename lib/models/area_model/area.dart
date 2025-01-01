class Area {
  int? areaId;
  String areaName;
  String city;
  String state;
  String pincode;

  Area({
    this.areaId,
    required this.areaName,
    required this.city,
    required this.state,
    required this.pincode,
  });

  // Convert an Area object into a map (for storing into SQLite)
  Map<String, dynamic> toMap() {
    return {
      'area_id': areaId,
      'area_name': areaName,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }

  // Convert a map into an Area object (for reading from SQLite)
  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      areaId: map['area_id'],
      areaName: map['area_name'],
      city: map['city'],
      state: map['state'],
      pincode: map['pincode'],
    );
  }
}
