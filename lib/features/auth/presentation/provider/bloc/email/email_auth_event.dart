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
  final String name;
  final String phone;
  final String email;
  final String password;

  const EmailAuthSignUp({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phone, email, password];
}

class EmailAuthSendPasswordReset extends EmailAuthEvent {
  final String email;

  const EmailAuthSendPasswordReset({required this.email});

  @override
  List<Object?> get props => [email];
}