class Area {
  final int areaId;
  final String areaName;

  Area({required this.areaId, required this.areaName});

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      areaId: map['area_id'],
      areaName: map['area_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'area_id': areaId,
      'area_name': areaName,
    };
  }
}
