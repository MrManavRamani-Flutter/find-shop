class User {
  final int userId;
  String username;
  String email;
  String password;
  String contact;
  int roleId;
  int status;
  String createdAt;

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

  // Setters
  set setUsername(String newUsername) {
    username = newUsername;
  }

  set setEmail(String newEmail) {
    email = newEmail;
  }

  set setContact(String newContact) {
    contact = newContact;
  }

  set setRoleId(int newRoleId) {
    roleId = newRoleId;
  }

  set setStatus(int newStatus) {
    status = newStatus;
  }

  set setCreatedAt(String newCreatedAt) {
    createdAt = newCreatedAt;
  }

  // CopyWith method to create a copy of the user with optional modifications
  User copyWith({
    int? userId,
    String? username,
    String? email,
    String? password,
    String? contact,
    int? roleId,
    int? status,
    String? createdAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      contact: contact ?? this.contact,
      roleId: roleId ?? this.roleId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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

  void updateUsername(String newUsername) {
    username = newUsername;
  }

  void updateEmail(String newEmail) {
    email = newEmail;
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
