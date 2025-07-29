import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  final String authMethod; // 'email', 'google', or 'phone'

  const AuthAuthenticated({required this.user, required this.authMethod});

  @override
  List<Object?> get props => [user, authMethod];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthEmailLoading extends AuthState {
  const AuthEmailLoading();
}

class AuthGoogleLoading extends AuthState {
  const AuthGoogleLoading();
}

class AuthOtpLoading extends AuthState {
  const AuthOtpLoading();
}

class OtpSent extends AuthState {
  final String verificationId;

  const OtpSent(this.verificationId);

  @override
  List<Object?> get props => [verificationId];
}

class OtpVerified extends AuthState {
  const OtpVerified();

  @override
  List<Object?> get props => [];
}