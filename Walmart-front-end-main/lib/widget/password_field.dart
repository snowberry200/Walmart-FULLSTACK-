// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:walmart/bloc/auth_state.dart' show AuthState;

import '../bloc/auth_bloc.dart';

class PasswordTextfield extends StatefulWidget {
  final TextEditingController controller;
  const PasswordTextfield({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  PasswordTextfieldState createState() => PasswordTextfieldState();
}

class PasswordTextfieldState extends State<PasswordTextfield> {
  bool _obscureText = true;
  late TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordController = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return TextFormField(
          controller: passwordController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }

            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }

            if (value.length > 30) {
              return 'Password must be less than 30 characters';
            }

            // Optional: Check for at least one number
            if (!RegExp(r'[0-9]').hasMatch(value)) {
              return 'Password must contain at least one number';
            }

            // Optional: Check for at least one letter
            if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
              return 'Password must contain at least one letter';
            }

            return null;
          },
        );
      },
    );
  }
}
