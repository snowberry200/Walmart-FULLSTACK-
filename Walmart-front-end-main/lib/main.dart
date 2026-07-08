// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walmart/auth_service/auth_repository.dart';
import 'package:walmart/bloc/auth_bloc.dart';
import 'package:walmart/data_source/remote_datasource_springboot.dart';
import 'package:walmart/firebase_options.dart';
import 'package:walmart/service/auth_service.dart';
import 'layout/layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final remoteDataSource = AuthRemoteDataSource();
  final authRepository = AuthRepository(remoteDataSource: remoteDataSource);
  final authService = AuthService(
    authRepository: authRepository,
    authRemoteDataSource: remoteDataSource,
  );

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(authService: authService),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthenticateWrapper(),
    );
  }
}

class AuthenticateWrapper extends StatelessWidget {
  const AuthenticateWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Layout();
  }
}
