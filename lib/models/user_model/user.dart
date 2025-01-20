class User {
  int? userId;
  String username;
  String email;
  String password;
  String contact;
  String userType;
  String status;
  String createdAt;

  User({
    this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.contact,
    required this.userType,
    required this.status,
    required this.createdAt,
  });

  /// Convert a `User` object into a map for storing into SQLite
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'password': password,
      'contact': contact,
      'user_type': userType,
      'status': status,
      'created_at': createdAt,
    };
  }

  /// Convert a map into a `User` object for reading from SQLite
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      contact: map['contact'],
      userType: map['user_type'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }

  /// Create a copy of the `User` object with optional new values
  User copyWith({
    int? userId,
    String? username,
    String? email,
    String? password,
    String? contact,
    String? userType,
    String? status,
    String? createdAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      contact: contact ?? this.contact,
      userType: userType ?? this.userType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
