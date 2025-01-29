class User {
  final int userId;
  final String username;
  final String email;
  final String password;
  final String contact;
  final int roleId;
  final int status; 
  final String createdAt;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.contact,
    required this.roleId,
    required this.status,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
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
}
