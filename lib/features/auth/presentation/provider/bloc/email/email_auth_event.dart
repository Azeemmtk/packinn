import 'package:equatable/equatable.dart';

abstract class EmailAuthEvent extends Equatable {
  const EmailAuthEvent();

  @override
  List<Object?> get props => [];
}

class EmailAuthSignIn extends EmailAuthEvent {
  final String email;
  final String password;

  const EmailAuthSignIn({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class EmailAuthSignUp extends EmailAuthEvent {
  final String email;
  final String password;
  final String name;
  final String phone;

  const EmailAuthSignUp({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });

  @override
  List<Object?> get props => [email, password, name, phone];
}

class EmailAuthSendPasswordReset extends EmailAuthEvent {
  final String email;

  const EmailAuthSendPasswordReset({required this.email});

  @override
  List<Object?> get props => [email];
}

class EmailAuthUpdatePassword extends EmailAuthEvent {
  final String uid;
  final String newPassword;

  const EmailAuthUpdatePassword({required this.uid, required this.newPassword});

  @override
  List<Object?> get props => [uid, newPassword];
}

class EmailAuthReset extends EmailAuthEvent {
  const EmailAuthReset();

  @override
  List<Object?> get props => [];
}