class RoleModel {
  int? roleId;
  String roleName;

  RoleModel({this.roleId, required this.roleName});

  Map<String, dynamic> toMap() {
    return {
      'role_id': roleId,
      'role_name': roleName,
    };
  }

  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return RoleModel(
      roleId: map['role_id'],
      roleName: map['role_name'],
    );
  }
}
