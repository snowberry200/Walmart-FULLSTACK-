// lib/data/repositories/auth_repository.dart
import 'package:walmart/Model/Response/user_dto.dart';
import 'package:walmart/data_source/data_source.dart';
import 'package:walmart/data_source/remote_datasource_springboot.dart';

import '../../Model/Request/auth_request_dto.dart';
import '../../Model/Response/auth_response_dto.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthDataSource? firebaseDataSource; // Optional fallback

  AuthRepository({
    required this.remoteDataSource,
    this.firebaseDataSource,
  });

  // sign in

  Future<AuthResponseDTO> signin(String email, String password) async {
    try {
      final request = AuthRequestDTO.forSignIn(email, password, true);
      return await remoteDataSource.signin(request);
    } catch (e) {
      // Fallback to Firebase if needed
      if (firebaseDataSource != null) {
        await firebaseDataSource!.firebaseLogin(email, password);
        // Convert Firebase data to AuthResponseDTO
        return AuthResponseDTO.forSignIn(
          UserDTO(id: 0, name: '', email: email, role: 'user', isActive: true),
          'firebase-token',
          'Logged in with Firebase',
          true,
        );
      }
      rethrow;
    }
  }

  //check email

  Future<AuthResponseDTO> checkEmail(String email) async {
    try {
      final request = AuthRequestDTO.checkEmail(email, true);
      final response = await remoteDataSource.checkEmail(request);

      // The response should now have the correct isActive value
      return response;
    } catch (e) {
      throw Exception('Failed to check email: $e');
    }
  }

// sign up

  Future<AuthResponseDTO> signup(
      String name, String email, String password) async {
    final request = AuthRequestDTO.forSignUp(name, email, password, true);
    return await remoteDataSource.signup(request);
  }
}
