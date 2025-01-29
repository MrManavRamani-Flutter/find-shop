class AreaModel {
  int? areaId;
  String areaName;

  AreaModel({
    this.areaId,
    required this.areaName,
  });

  Map<String, dynamic> toMap() {
    return {
      'area_id': areaId,
      'area_name': areaName,
    };
  }

  factory AreaModel.fromMap(Map<String, dynamic> map) {
    return AreaModel(
      areaId: map['area_id'],
      areaName: map['area_name'],
    );
  }
}
