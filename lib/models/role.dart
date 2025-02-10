class Role {
  final int roleId;
  final String roleName;

  Role({required this.roleId, required this.roleName});

  // Factory constructor to create a Role object from a map
  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      roleId: map['role_id'], // Assigning roleId from map
      roleName: map['role_name'], // Assigning roleName from map
    );
  }

  // Convert Role object to a map
  Map<String, dynamic> toMap() {
    return {
      'role_id': roleId, // Mapping roleId to map
      'role_name': roleName, // Mapping roleName to map
    };
  }
}
