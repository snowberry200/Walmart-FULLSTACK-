import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walmart/bloc/auth_bloc.dart';
import 'package:walmart/bloc/auth_event.dart';
import 'package:walmart/bloc/auth_state.dart';

class SignUpButton extends StatefulWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const SignUpButton({
    Key? key,
    required this.formkey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  Future<void> _handleSignup() async {
    context.read<AuthBloc>().add(SignUpEvent(
          userEmail: widget.emailController.text,
          userPassword: widget.passwordController.text,
          userName: widget.nameController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show loading indicator if signing up
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 37, 98, 228),
              ),
            ),
          );
        }

        return ElevatedButton(
          onPressed: state.isLoading ? null : _handleSignup,
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            backgroundColor: CupertinoColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(width: 1),
            ),
            minimumSize: const Size.fromHeight(50),
            fixedSize: const Size(150, 30),
          ),
          child: Text(
            state.isSignedIn ? 'Create account' : 'Sign in',
            style: TextStyle(
              decorationThickness: 1,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: CupertinoColors.black,
            ),
          ),
        );
      },
    );
  }
}
