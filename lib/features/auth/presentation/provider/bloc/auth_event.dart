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
  final String name;
  final String phone;
  final String email;
  final String password;

  const AuthSignUpWithEmailEvent({
    required this.name,
    required this.phone,
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

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;

  const SendOtpEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String verificationId;
  final String otp;

  const VerifyOtpEvent(this.verificationId, this.otp);

  @override
  List<Object> get props => [verificationId, otp];
}
