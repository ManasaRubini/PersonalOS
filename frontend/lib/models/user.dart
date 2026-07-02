class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String role;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
  });

  /// Empty user
  factory UserModel.empty() {
    return const UserModel(
      userId: '',
      fullName: '',
      email: '',
      role: '',
    );
  }

  /// From API JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "full_name": fullName,
      "email": email,
      "role": role,
    };
  }

  /// Copy with
  UserModel copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? role,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, fullName: $fullName, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserModel &&
            runtimeType == other.runtimeType &&
            userId == other.userId &&
            fullName == other.fullName &&
            email == other.email &&
            role == other.role;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      role.hashCode;
}