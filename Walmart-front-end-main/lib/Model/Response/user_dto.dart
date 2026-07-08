class UserDTO {
  final int id;
  final String name;
  final String email;
  final String? role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    required this.isActive,
    this.createdAt,
    this.lastLogin,
  });

  // ✅ No null check needed - json can never be null
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? json['active'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lastLogin:
          json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }
}
