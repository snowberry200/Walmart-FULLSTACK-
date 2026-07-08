// lib/service/auth_service.dart (REFACTORED)
import 'package:walmart/Model/Request/auth_request_dto.dart';
import 'package:walmart/Model/Response/auth_response_dto.dart';
import 'package:walmart/auth_service/auth_repository.dart';
import 'package:walmart/data_source/remote_datasource_springboot.dart';

class AuthService {
  final AuthRepository authRepository;
  final AuthRemoteDataSource authRemoteDataSource;

  AuthService(
      {required this.authRepository, required this.authRemoteDataSource});

  // For Spring Boot
  Future<AuthResponseDTO> signin(
      {required String email, required String password}) async {
    return await authRepository.signin(email, password);
  }

  Future<AuthResponseDTO> checkEmail(String email) async {
    try {
      final request =
          AuthRequestDTO(email: email, password: '', name: '', isActive: false);
      return await authRemoteDataSource.checkEmail(request);
    } catch (e) {
      throw Exception('Failed to check email: $e');
    }
  }

  Future<AuthResponseDTO> signup(
      {required String name,
      required String email,
      required String password}) async {
    return await authRepository.signup(name, email, password);
  }

  // For Firebase (kept for backward compatibility)
  Future<Map<String, dynamic>> login(
      {required String username, required String pass}) async {
    // This would call firebaseDataSource directly if needed
    throw UnimplementedError('Use new auth flow');
  }

  Future<void> register(
      {required String name,
      required String username,
      required String password}) async {
    throw UnimplementedError('Use new auth flow');
  }
}
