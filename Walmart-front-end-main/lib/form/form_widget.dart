import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walmart/bloc/auth_bloc.dart' show AuthBloc;
import 'package:walmart/bloc/auth_event.dart';
import 'package:walmart/bloc/auth_state.dart';
import 'package:walmart/form/form_widget_factory.dart';
import 'package:walmart/widget/shared_data.dart';
import 'package:walmart/widget/submit_button.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(
      text: SharedAuthData.lastEmail ?? '',
    );
    passwordController = TextEditingController(
      text: SharedAuthData.lastPassword,
    );
  }

  void _swap(AuthState state) {
    // Clear any existing messages before toggling
    context.read<AuthBloc>().add(ToggleFormModeEvent(eventIsToggled: true));
    formKey.currentState?.reset();

    // Clear the form fields
    emailController.clear();
    nameController.clear();
    passwordController.clear();
  }

  void _handleSubmit(AuthState state) {
    if (kDebugMode) {
      print('🔍 _handleSubmit called');
      print('🔍 isSignUp: ${state.isSignUp}');
    }

    // Validate form
    if (!formKey.currentState!.validate()) {
      if (kDebugMode) {
        print('❌ Form validation FAILED!');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields correctly'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final password = passwordController.text.trim();

    // ==========================================
    // SIGN UP FLOW
    // ==========================================
    if (state.isSignUp) {
      if (kDebugMode) {
        print('🔍 SIGN UP - email: $email');
      }
      context.read<AuthBloc>().add(
            SignUpEvent(
              userEmail: email,
              userPassword: password,
              userName: name,
            ),
          );
      return;
    }

    /// ==========================================
    // login FLOW
    /// ==========================================
    if (state.logIn) {
      if (kDebugMode) {
        print('🔍 LOGIN - email: $email');
      }
      context.read<AuthBloc>().add(
            LoginEvent(
              userEmail: email,
            ),
          );
      return;
    }

    /// ==========================================
    // Email Continue FLOW
    /// ==========================================
    if (state.emailContinue) {
      if (kDebugMode) {
        print('🔍 EMAIL CONTINUE - email: $email');
      }
      context.read<AuthBloc>().add(
            EmailContinueEvent(
              userEmail: email,
              userPassword: password,
            ),
          );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (kDebugMode) {
          print(
              ' FormWidget build - isSignUp: ${state.isSignUp}, isLoading: ${state.isLoading}');
        }

        return Form(
          key: formKey,
          child: Column(
            children: [
              // Email Field - Always visible
              FormWidgetFactory.createEmailTextField(emailController),

              // Show password and name fields only during sign up
              if (state.isSignUp) ...[
                const SizedBox(height: 20),
                FormWidgetFactory.createPasswordTextfield(passwordController),
                const SizedBox(height: 20),
                FormWidgetFactory.createNameTextField(nameController),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 25),

              // Submit Button
              SubmitButton(
                formKey: formKey,
                emailController: emailController,
                name: nameController.text,
                password: passwordController,
                isSignUp: state.isSignUp,
                isLoading: state.isLoading,
                handleLogin: () => _handleSubmit(state),
              ),

              const SizedBox(height: 20),

              // Toggle between Sign In and Sign Up
              const Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => _swap(state),
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
                  state.isSignUp ? 'Sign in' : 'Create account',
                  style: const TextStyle(
                    decorationThickness: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: CupertinoColors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
