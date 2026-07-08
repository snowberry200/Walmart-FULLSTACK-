import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walmart/bloc/auth_state.dart';

import '../bloc/auth_bloc.dart';

class EmailTextField extends StatefulWidget {
  final TextEditingController? controller;

  const EmailTextField({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  State<EmailTextField> createState() => EmailTextFieldState();
}

class EmailTextFieldState extends State<EmailTextField> {
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    emailController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return TextFormField(
            controller: emailController, // Use the controller
            selectionControls: CupertinoDesktopTextSelectionControls(),
            cursorColor: Colors.blue,
            enableIMEPersonalizedLearning: true,
            textCapitalization: TextCapitalization.none,
            enableInteractiveSelection: true,
            autofillHints: const [AutofillHints.email],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(),
              focusColor: CupertinoColors.black,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              labelText: 'Email Address',
              contentPadding: EdgeInsets.all(10),
            ),
            validator: (ifemail) =>
              (ifemail != null && EmailValidator.validate(ifemail))
                ? null
                : 'Enter a valid email',
          );
      },
    );
  }
}
