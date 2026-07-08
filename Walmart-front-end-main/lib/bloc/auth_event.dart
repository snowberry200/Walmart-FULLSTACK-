// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  final String email;
  final dynamic password;
  final String? name;
  final String? message;
  final String? errorMessage;
  final bool? isToggled;

  const AuthEvent(
      {required this.email,
      this.password,
      required this.name,
      this.message,
      this.errorMessage,
      this.isToggled});
  @override
  List<Object?> get props =>
      [email, password, name, message, errorMessage, isToggled];
}

///===================================///
// EmailContinueEvent Event
///===================================///

class EmailContinueEvent extends AuthEvent {
  const EmailContinueEvent({
    required String userEmail,
    required dynamic userPassword,
    String? userName,
    String? message,
    String? errorMessage,
  }) : super(
          email: userEmail,
          password: userPassword,
          name: userName,
          message: message,
          errorMessage: errorMessage,
        );
}

///===================================///
//  Login Event
///===================================///
class LoginEvent extends AuthEvent {
  const LoginEvent({
    required String userEmail,
    String? message,
    String? errorMessage,
  }) : super(
          email: userEmail,
          password: null,
          name: null,
          message: message,
          errorMessage: errorMessage,
        );
}

///===================================///
// SignUp Event
///===================================///
class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required String userEmail,
    required dynamic userPassword,
    required String userName,
    String? message,
    String? errorMessage,
  }) : super(
          email: userEmail,
          password: userPassword,
          name: userName,
          message: message,
          errorMessage: errorMessage,
        );
}

///===================================///
// AuthError Event
///===================================///
class AuthErrorEvent extends AuthEvent {
  const AuthErrorEvent({
    required String errorMessage,
    String? message,
  }) : super(
          email: '',
          password: '',
          name: '',
          message: message,
          errorMessage: errorMessage,
        );
}

///===================================///
// ToggleFormMode Event
///===================================///
class ToggleFormModeEvent extends AuthEvent {
  const ToggleFormModeEvent({
    required bool eventIsToggled,
    String? message,
    String? errorMessage,
  }) : super(
          isToggled: eventIsToggled,
          email: '',
          password: '',
          name: '',
          message: message,
          errorMessage: errorMessage,
        );
}
