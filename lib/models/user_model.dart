class UserModel {
  int? userId;
  String username;
  String email;
  String password;
  String contact;
  int roleId;
  int status;
  String createdAt;

  UserModel({
    this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.contact,
    required this.roleId,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'password': password,
      'contact': contact,
      'role_id': roleId,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      contact: map['contact'],
      roleId: map['role_id'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }
}
