import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:walmart/Model/Request/auth_request_dto.dart';
import 'package:walmart/Model/Response/auth_response_dto.dart';
import 'package:walmart/Model/Response/user_dto.dart';
import 'package:walmart/data_source/data_source.dart';

class AuthRemoteDataSource implements AuthDataSource {
  static String get baseUrl {
    if (kIsWeb) {
      // For web - use your computer's IP or 127.0.0.1
      return "http://127.0.0.1:8080/api/auth";
      // OR use your local IP:
      // return "http://192.168.1.100:8080/api/auth";
    } else if (Platform.isAndroid) {
      // For Android emulator
      return "http://10.0.2.2:8080/api/auth";
    } else if (Platform.isIOS) {
      // For iOS simulator
      return "http://localhost:8080/api/auth";
    } else {
      return "http://localhost:8080/api/auth";
    }
  }

  final http.Client client;

  AuthRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<AuthResponseDTO> signin(AuthRequestDTO request) async {
    try {
      final uri = Uri.parse('$baseUrl/login');
      print('🌐 SIGNIN URL: $uri');
      print('🌐 Request body: ${jsonEncode(request.toJson())}');

      final response = await client
          .post(
            uri,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Connection timeout'),
          );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        return AuthResponseDTO.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Invalid email or password');
      } else if (response.statusCode == 404) {
        throw Exception(
            'Login endpoint not found. Please check:\n1. Spring Boot is running\n2. URL is correct: $uri\n3. Controller has @PostMapping("/login")');
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('❌ Client error: $e');
      throw Exception(
          'Cannot connect to server at $baseUrl. Please check if Spring Boot is running.');
    } catch (e) {
      print('❌ Signin error: $e');
      throw Exception('Signin error: $e');
    }
  }

  //check email
  @override
  Future<AuthResponseDTO> checkEmail(AuthRequestDTO request) async {
    try {
      final uri = Uri.parse('$baseUrl/check-email');
      print('📧 CHECK EMAIL URL: $uri');
      print('📧 Request body: ${jsonEncode(request.toJson())}');

      final response = await client
          .post(
            uri,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Connection timeout'),
          );

      print('📧 Response status: ${response.statusCode}');
      print('📧 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('📧 Parsed response: $jsonResponse');

        bool isActive =
            jsonResponse['isActive'] ?? jsonResponse['active'] ?? false;

        return AuthResponseDTO.forEmailCheck(
          emailExists: jsonResponse['emailExists'] ?? false,
          message: jsonResponse['message'] ?? '',
          user: jsonResponse['userDTO'] != null
              ? UserDTO.fromJson(jsonResponse['userDTO'])
              : null,
          isActive: isActive,
        );
      } else if (response.statusCode == 404) {
        throw Exception(
            'Check email endpoint not found. Please check:\n1. Spring Boot is running\n2. URL is correct: $uri\n3. Controller has @PostMapping("/check-email")');
      } else {
        throw Exception('Failed to check email: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('❌ Client error: $e');
      throw Exception(
          'Cannot connect to server at $baseUrl. Please check if Spring Boot is running.');
    } catch (e) {
      print('❌ Check email error: $e');
      throw Exception('Check email error: $e');
    }
  }

  //sign up
  @override
  Future<AuthResponseDTO> signup(AuthRequestDTO request) async {
    try {
      final uri = Uri.parse('$baseUrl/register');
      print('📝 SIGNUP URL: $uri');
      print('📝 Request body: ${jsonEncode(request.toJson())}');

      final response = await client
          .post(
            uri,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Connection timeout'),
          );

      print('📝 Response status: ${response.statusCode}');
      print('📝 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseDTO.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception('Registration failed: ${errorData['message']}');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('❌ Client error: $e');
      throw Exception(
          'Cannot connect to server. Please check if Spring Boot is running.');
    } catch (e) {
      print('❌ Signup error: $e');
      throw Exception('Signup error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> firebaseLogin(
      String email, String password) async {
    throw UnsupportedError('Firebase not supported in RemoteDataSource');
  }

  @override
  Future<void> firebaseRegister(
      String name, String email, String password) async {
    throw UnsupportedError('Firebase not supported in RemoteDataSource');
  }
}
