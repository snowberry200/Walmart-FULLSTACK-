import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationClient {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;
  //sign in with email and Password
  Future signIn({required String email, required String password}) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
