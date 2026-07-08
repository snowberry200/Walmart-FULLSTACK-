// lib/data/datasources/firebase/firebase_auth_data_source.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walmart/Model/Request/auth_request_dto.dart';
import 'package:walmart/Model/Response/auth_response_dto.dart';
import 'package:walmart/data_source/data_source.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseFirestore firestore;

  FirebaseAuthDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<AuthResponseDTO> signin(AuthRequestDTO request) async {
    throw UnsupportedError('Use firebaseLogin for Firebase auth');
  }

  @override
  Future<AuthResponseDTO> signup(AuthRequestDTO request) async {
    throw UnsupportedError('Use firebaseRegister for Firebase auth');
  }

  @override
  Future<Map<String, dynamic>> firebaseLogin(
      String email, String password) async {
    try {
      final querySnapshot = await firestore
          .collection('credential')
          .where('user', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Invalid email or password');
      }

      return querySnapshot.docs.first.data();
    } catch (e) {
      throw Exception('Firebase login error: $e');
    }
  }

  @override
  Future<void> firebaseRegister(
      String name, String email, String password) async {
    try {
      final existingUser = await firestore
          .collection('credential')
          .where('user', isEqualTo: email)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        throw Exception('User with this email already exists');
      }

      await firestore.collection('credential').add({
        'name': name,
        'user': email,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Firebase registration error: $e');
    }
  }

  @override
  Future<AuthResponseDTO> checkEmail(AuthRequestDTO request) {
    // TODO: implement checkEmail
    throw UnimplementedError();
  }
}
