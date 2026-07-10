import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:walmart/bloc/auth_event.dart';
import 'package:walmart/bloc/auth_state.dart';
import 'package:walmart/service/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthState()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<EmailContinueEvent>(_onEmailContinueEvent);
    on<ToggleFormModeEvent>(_onToggleFormModeEvent);
    on<AuthErrorEvent>(_onAuthErrorEvent);
  }

  /// ==========================================
  // LOGIN EVENT (Step 1)
  /// ==========================================
  Future<void> _onLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      message: 'Verifying credentials...',
    ));

    try {
      if (event.email.isNotEmpty) {
        final email = event.email.trim().toLowerCase();
        final response = await authService.checkEmail(email);

        if (response.emailExists == true) {
          if (kDebugMode) {
            print('Email exists');
          }
          emit(state.copyWith(
              isSignedIn: false,
              emailContinue: true,
              email: email,
              welcome: false,
              isSignUp: false,
              logIn: false,
              isLoading: false,
              status: 'ACTIVE',
              userData: response.user?.toJson(),
              authResponse: response,
              errorMessage: null,
              message: '$email verified, enter password'));
        } else {
          emit(state.copyWith(
            isSignedIn: false,
            emailContinue: false,
            email: email,
            isSignUp: true,
            logIn: false,
            isLoading: false,
            status: 'NOT_ACTIVE',
            userData: response.user?.toJson(),
            authResponse: response,
            errorMessage: null,
            message:
                '$email does not exist. Please sign up to create an account.',
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// ==========================================
  // EMAIL CONTINUE EVENT 2
  /// ==========================================

  Future<void> _onEmailContinueEvent(
    EmailContinueEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
        isLoading: true, message: 'Authenticating...', errorMessage: null));

    try {
      final response = await authService.signin(
          email: event.email, password: event.password);

      if (response.accessToken != null && response.accessToken!.isNotEmpty) {
        if (kDebugMode) {
          print('Authentication successful - token received');
        }

        final newState = state.copyWith(
          isSignedIn: true,
          isSignUp: false,
          emailContinue: false,
          welcome: true,
          logIn: false,
          email: event.email,
          isLoading: false,
          message: response.message,
          status: 'ACTIVE',
          userData: response.user?.toJson(),
          authResponse: response,
        );
        await Future.delayed(const Duration(milliseconds: 100));
        emit(newState);
        if (kDebugMode) {
          print(
              '📢 Emitting new state: isSignedIn=${newState.isSignedIn}, status=${newState.status}, welcome=${newState.welcome}');
        }
      } else {
        if (kDebugMode) {
          print(' Authentication failed - no token received');
        }
        emit(state.copyWith(
          isSignedIn: false,
          isSignUp: false,
          emailContinue: false,
          welcome: false,
          logIn: true,
          isLoading: false,
          errorMessage: response.message,
          status: 'AUTH_FAILED',
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during signin: $e');
      }
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        status: 'ERROR',
        logIn: true,
      ));
    }
  }

  // ==========================================
// SIGN UP EVENT
// ==========================================

  Future<void> _onSignUpEvent(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      message: 'Creating your account...',
    ));

    try {
      final response = await authService.signup(
        name: event.name!,
        email: event.email,
        password: event.password,
      );

      // Simulate a delay to show the loading indicator
      await Future.delayed(const Duration(seconds: 2));

      //Check if registration was successful (has accessToken or user)
      if (response.accessToken != null && response.accessToken!.isNotEmpty) {
        if (kDebugMode) {
          print('Registration successful for: ${event.email}');
        }

        // Success - go back to login page
        emit(state.copyWith(
          isSignedIn: false,
          isSignUp: false,
          logIn: true,
          emailContinue: false,
          email: event.email,
          name: event.name,
          isLoading: false,
          status: 'ACTIVE',
          registrationCompleted: true,
          errorMessage: null,
          message:
              '${event.name}, your account was successfully created! Please sign in to continue.',
          userData: response.user?.toJson(),
          authResponse: response,
        ));
      } else {
        //  Registration failed - no access token
        if (kDebugMode) {
          print('Registration failed for: ${event.email}');
        }
        emit(state.copyWith(
          isLoading: false,
          registrationCompleted: false,
          errorMessage: response.message,
          message: null,
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print(' Signup error: $e');
      }
      emit(state.copyWith(
        isLoading: false,
        registrationCompleted: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  // ==========================================
  // TOGGLE FORM MODE
  // ==========================================

  Future<void> _onToggleFormModeEvent(
    ToggleFormModeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      isSignedIn: false,
      isSignUp: !state.isSignUp,
      logIn: !state.isSignUp,
      emailContinue: false,
      errorMessage: null,
      message: null,
      status: null,
      isLoading: false,
    ));
  }

  /// ==========================================
  // AUTH ERROR
  /// ==========================================

  FutureOr<void> _onAuthErrorEvent(
    AuthErrorEvent event,
    Emitter<AuthState> emit,
  ) {
    final errorMsg = event.errorMessage;

    if (errorMsg!.contains('not found') ||
        errorMsg.contains('invalid credentials') ||
        errorMsg.contains('user does not exist')) {
      emit(state.copyWith(
        errorMessage: 'You cannot sign in. Please register your account first.',
      ));
    } else {
      emit(state.copyWith(errorMessage: event.errorMessage));
    }
  }
}
