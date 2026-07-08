import 'package:walmart/Model/Response/user_dto.dart';

class AuthResponseDTO {
  final UserDTO? user;
  final String? accessToken;
  final String message;
  final bool isActive;
  final bool requiresVerification;
  final String? verificationToken;
  final bool emailExists;

  AuthResponseDTO({
    required this.emailExists,
    this.user,
    this.accessToken,
    required this.message,
    this.requiresVerification = false,
    this.isActive = false,
    this.verificationToken,
  });

  factory AuthResponseDTO.forSignIn(
    UserDTO user,
    String accessToken,
    String message,
    bool isActive,
  ) {
    return AuthResponseDTO(
      user: user,
      accessToken: accessToken,
      message: message,
      requiresVerification: false,
      verificationToken: '',
      isActive: isActive,
      emailExists: true,
    );
  }

  factory AuthResponseDTO.forSignUp(
    String message,
    String verificationToken,
    UserDTO user,
    String accessToken,
    bool isActive,
  ) {
    return AuthResponseDTO(
      user: user,
      accessToken: accessToken,
      message: message,
      requiresVerification: true,
      verificationToken: verificationToken,
      isActive: isActive,
      emailExists: true,
    );
  }

  factory AuthResponseDTO.forEmailCheck({
    required bool emailExists,
    String? message,
    UserDTO? user,
    bool isActive = false, // 👈 Add this parameter
  }) {
    return AuthResponseDTO(
      user: user,
      accessToken: null,
      message:
          message ?? (emailExists == true ? 'Email found' : 'Email not found'),
      isActive: isActive,
      requiresVerification: false,
      verificationToken: null,
      emailExists: emailExists,
    );
  }

  factory AuthResponseDTO.fromJson(Map<String, dynamic> json) {
    return AuthResponseDTO(
      user: json['userDTO'] != null ? UserDTO.fromJson(json['userDTO']) : null,
      emailExists: json['emailExists'] ?? false,
      accessToken: json['accessToken'],
      message: json['message'] ?? '',
      requiresVerification: json['requiresVerification'] ?? false,
      verificationToken: json['verificationToken'] ?? '',
      isActive: json['isActive'] ?? json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userDTO': user?.toJson(),
      'accessToken': accessToken,
      'emailExists': emailExists,
      'message': message,
      'requiresVerification': requiresVerification,
      'verificationToken': verificationToken,
      'isActive': isActive,
    };
  }
}
