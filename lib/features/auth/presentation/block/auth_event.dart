import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {
  const AuthCheckStatusEvent();
}

class AuthSignInWithGoogleEvent extends AuthEvent {
  const AuthSignInWithGoogleEvent();
}

class AuthSignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInWithEmailEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpWithEmailEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}

class AuthSendPasswordResetEvent extends AuthEvent {
  final String email;

  const AuthSendPasswordResetEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthVerifyOTPEvent extends AuthEvent {
  final String otp;

  const AuthVerifyOTPEvent({required this.otp});

  @override
  List<Object?> get props => [otp];
}
