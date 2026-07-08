// // authenticate_wrapper.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:walmart/bloc/auth_bloc.dart';

// class AuthenticateWrapper extends StatelessWidget {
//   const AuthenticateWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthBloc, AuthState>(
//       listener: (context, state) {
//         // Handle side effects (navigation, dialogs, etc.)
//         if (state is AuthError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       builder: (context, state) {
//         // Handle different authentication states
//         if (state is AuthInitial || state is AuthLoading) {
//           return const SplashScreen();
//         }
        
//         if (state is Authenticated) {
//           return const HomePage(); // User is logged in
//         }
        
//         if (state is Unauthenticated) {
//           return const LoginPage(); // User is not logged in
//         }
        
//         // Fallback for error state
//         return const LoginPage();
//       },
//     );
//   }
// }