// lib/data/datasources/auth_data_source.dart
import 'package:walmart/Model/Request/auth_request_dto.dart';
import 'package:walmart/Model/Response/auth_response_dto.dart';

abstract class AuthDataSource {
  Future<AuthResponseDTO> signin(AuthRequestDTO request);
  Future<AuthResponseDTO> signup(AuthRequestDTO request);
  Future<AuthResponseDTO> checkEmail(AuthRequestDTO request);

  // Firebase specific
  Future<Map<String, dynamic>> firebaseLogin(String email, String password);
  Future<void> firebaseRegister(String name, String email, String password);
}
