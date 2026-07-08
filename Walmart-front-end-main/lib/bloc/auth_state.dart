import 'package:equatable/equatable.dart';
import 'package:walmart/Model/Response/auth_response_dto.dart';

class AuthState extends Equatable {
  // flags state change
  final bool logIn; // Indicates if the user is sign in process
  final bool isSignUp; //  Indicates if the user is in the signup process
  final bool
      emailContinue; //  Indicates if the user email is verified and awaiting to enter password
  final bool welcome; //  Indicates if the user is in the welcome screen

  // authentication states
  final bool isSignedIn; //  Indicates if the user is signed in
  final bool
      registrationCompleted; //  Indicates if the user has completed the registration process

  // data for signin
  final String email;
  final String password;

  // data for signup
  final String? name;

  // common data
  final bool isLoading;
  final String? status;
  final String? message;
  final Map<String, dynamic>? userData;
  final bool? isToggled;
  final String? errorMessage;
  final AuthResponseDTO? authResponse;

  // initial values
  const AuthState({
    this.isToggled = false,
    this.isSignedIn = false, //  User is not signed in initially
    this.logIn = true, //  User is in the sign-in process initially
    this.isSignUp = false,
    this.emailContinue = false,
    this.email = '',
    this.password = '',
    this.name = '',
    this.isLoading = false,
    this.status,
    this.message,
    this.userData,
    this.errorMessage,
    this.authResponse,
    this.welcome = false,
    this.registrationCompleted = false,
  });

  @override
  List<Object?> get props => [
        logIn,
        isLoading,
        isSignedIn,
        isSignUp,
        emailContinue,
        email,
        password,
        name,
        status,
        authResponse,
        registrationCompleted,
        welcome,
        message,
        errorMessage,
        userData,
        isToggled,
      ];

  AuthState copyWith({
    bool? isToggled,
    bool? logIn,
    bool? isSignedIn,
    bool? isSignUp,
    bool? emailContinue,
    String? email,
    String? password,
    String? name,
    bool? isLoading,
    String? status,
    String? message,
    Map<String, dynamic>? userData,
    String? errorMessage,
    bool? welcome,
    bool? registrationCompleted,
    AuthResponseDTO? authResponse,
  }) {
    return AuthState(
      logIn: logIn ?? this.logIn,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      isSignUp: isSignUp ?? this.isSignUp,
      emailContinue: emailContinue ?? this.emailContinue,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      message: message ?? this.message,
      userData: userData ?? this.userData,
      errorMessage: errorMessage ?? this.errorMessage,
      welcome: welcome ?? this.welcome,
      registrationCompleted:
          registrationCompleted ?? this.registrationCompleted,
      authResponse: authResponse ?? this.authResponse,
      isToggled: isToggled ?? this.isToggled,
    );
  }
}
