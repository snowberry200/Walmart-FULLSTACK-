// lib/widget/submit_button.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback handleLogin;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final String? name;
  final TextEditingController password;
  final bool isSignUp;
  final bool isLoading;

  const SubmitButton({
    Key? key,
    required this.handleLogin,
    required this.formKey,
    required this.emailController,
    required this.name,
    required this.password,
    this.isSignUp = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isLoading
            ? Colors.grey[400]
            : const Color.fromARGB(255, 37, 98, 228),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size.fromHeight(50),
        fixedSize: const Size(150, 30),
      ),
      onPressed: isLoading ? null : handleLogin,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              isSignUp ? 'Register' : 'Continue',
              style: const TextStyle(color: CupertinoColors.white),
            ),
    );
  }
}
