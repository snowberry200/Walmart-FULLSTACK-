// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:walmart/bloc/auth_bloc.dart';
// import 'package:walmart/bloc/auth_event.dart';
// import 'package:walmart/widget/image_container.dart';
// import 'package:walmart/widget/password_field.dart';
// import '../../bloc/auth_state.dart';
// import '../../layout/layout.dart';

// class PasswordMobileForm extends StatefulWidget {
//   final String callback;
//   const PasswordMobileForm({
//     Key? key,
//     required this.callback,
//   }) : super(key: key);

//   @override
//   State<PasswordMobileForm> createState() => _PasswordMobileFormState();
// }

// class _PasswordMobileFormState extends State<PasswordMobileForm> {
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey();
//   bool isChecked = true;

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleLogin() async {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }

//     final password = _passwordController.text.trim();
//     print('🔐 Attempting login with password: $password');

//     if (password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter your password'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     context.read<AuthBloc>().add(
//         EmailContinueEvent(userEmail: widget.callback, userPassword: password));
//   }

//   void _handleActiveUser(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Login successful! 🎉"),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 2),
//       ),
//     );

//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const Layout()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthBloc, AuthState>(
//       listener: (context, state) {
//         // Handle errors
//         if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.errorMessage!),
//               backgroundColor: Colors.red,
//               duration: const Duration(seconds: 3),
//             ),
//           );
//           return;
//         }

//         // Handle successful login
//         if (state.isSignedIn == true && state.status == 'ACTIVE') {
//           _handleActiveUser(state.message ?? 'Logged in successfully');
//           return;
//         }

//         // Handle authentication failure
//         if (state.status == 'AUTH_FAILED') {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message ?? 'Invalid email or password'),
//               backgroundColor: Colors.red,
//               duration: const Duration(seconds: 3),
//             ),
//           );
//           return;
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: CupertinoColors.white,
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: Center(child: ImageContainer()),
//                     ),
//                     const SizedBox(height: 30),
//                     Center(
//                       child: Form(
//                         key: formKey,
//                         child: Column(
//                           children: [
//                             const Text(
//                               'Enter your password',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             const Text(
//                               'Email address',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w400,
//                                 letterSpacing: 1.0,
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.only(bottom: 20, top: 20),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       widget.callback,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: const TextStyle(
//                                         fontStyle: FontStyle.italic,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w400,
//                                         letterSpacing: 1.0,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   InkWell(
//                                     child: const Center(
//                                       child: Text(
//                                         'Change',
//                                         style: TextStyle(
//                                           color: Colors.blue,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w400,
//                                           letterSpacing: 1.0,
//                                           decoration: TextDecoration.underline,
//                                           decorationColor: Colors.blue,
//                                         ),
//                                       ),
//                                     ),
//                                     onTap: () {
//                                       Navigator.of(context).pushReplacement(
//                                         MaterialPageRoute(
//                                           builder: (context) => const Layout(),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // ✅ Use the controller
//                             PasswordTextfield(
//                               controller: _passwordController,
//                             ),
//                             const SizedBox(height: 20),
//                             Align(
//                               alignment: Alignment.topRight,
//                               child: MaterialButton(
//                                 hoverColor: Colors.white,
//                                 onPressed: () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           'Password reset link will be sent to your email'),
//                                       duration: Duration(seconds: 2),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text(
//                                   'Forgot password?',
//                                   style: TextStyle(
//                                     decoration: TextDecoration.underline,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Center(
//                               child: state.isLoading
//                                   ? const CircularProgressIndicator()
//                                   : ElevatedButton(
//                                       onPressed: _handleLogin,
//                                       style: ElevatedButton.styleFrom(
//                                         elevation: 0,
//                                         backgroundColor: const Color.fromARGB(
//                                             255, 37, 98, 228),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         minimumSize: const Size.fromHeight(50),
//                                         fixedSize: const Size(150, 30),
//                                       ),
//                                       child: const Text(
//                                         'Sign in',
//                                         style: TextStyle(
//                                             color: CupertinoColors.white),
//                                       ),
//                                     ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walmart/bloc/auth_bloc.dart';
import 'package:walmart/bloc/auth_event.dart';
import 'package:walmart/widget/image_container.dart';
import 'package:walmart/widget/password_field.dart';
import '../../bloc/auth_state.dart';
import '../../layout/layout.dart';
import '../../widget/welcome_screen.dart'; // ✅ Add this import

class PasswordMobileForm extends StatefulWidget {
  final String callback;
  const PasswordMobileForm({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<PasswordMobileForm> createState() => _PasswordMobileFormState();
}

class _PasswordMobileFormState extends State<PasswordMobileForm> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isChecked = true;
  bool _isNavigating = false; // ✅ Prevent multiple navigations

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final password = _passwordController.text.trim();
    print('🔐 Attempting login with password: $password');

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
        EmailContinueEvent(userEmail: widget.callback, userPassword: password));
  }

  void _handleActiveUser(String message) {
    // ✅ Prevent multiple navigations
    if (_isNavigating) return;
    _isNavigating = true;

    final userName = context.read<AuthBloc>().state.userData?['name'] ?? '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Login successful! Welcome${userName.isNotEmpty ? ' $userName' : ''} 🎉"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // ✅ Navigate to WelcomeScreen directly from here
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(
              userName: userName,
              email: widget.callback,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print('📢 PasswordScreen Listener:');
        print('  isSignedIn: ${state.isSignedIn}');
        print('  status: ${state.status}');
        print('  isLoading: ${state.isLoading}');
        print('  errorMessage: ${state.errorMessage}');
        print('  message: ${state.message}');
        print('  welcome: ${state.welcome}');

        // ==========================================
        // 1. HANDLE ERRORS FIRST
        // ==========================================
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          return;
        }

        // ==========================================
        // 2. HANDLE SUCCESSFUL LOGIN - ✅ NAVIGATE HERE
        // ==========================================
        if (state.isSignedIn == true && state.status == 'ACTIVE') {
          print('✅ User signed in successfully - navigating to welcome screen');
          _handleActiveUser(state.message ?? 'Logged in successfully');
          return;
        }

        // ==========================================
        // 3. HANDLE AUTHENTICATION FAILURE
        // ==========================================
        if (state.status == 'AUTH_FAILED') {
          print('❌ Authentication failed');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Invalid email or password'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          // ✅ Reset navigation flag so user can retry
          _isNavigating = false;
          return;
        }

        // ==========================================
        // 4. HANDLE OTHER STATES
        // ==========================================
        if (state.isLoading) {
          print('⏳ Loading...');
          return;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CupertinoColors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(child: ImageContainer()),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const Text(
                              'Enter your password',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Email address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.callback,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    child: const Center(
                                      child: Text(
                                        'Change',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1.0,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => const Layout(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            PasswordTextfield(
                              controller: _passwordController,
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.topRight,
                              child: MaterialButton(
                                hoverColor: Colors.white,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Password reset link will be sent to your email'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: state.isLoading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: const Color.fromARGB(
                                            255, 37, 98, 228),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        minimumSize: const Size.fromHeight(50),
                                        fixedSize: const Size(150, 30),
                                      ),
                                      child: const Text(
                                        'Sign in',
                                        style: TextStyle(
                                            color: CupertinoColors.white),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
