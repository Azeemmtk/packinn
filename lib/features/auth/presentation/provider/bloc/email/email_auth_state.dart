import 'package:equatable/equatable.dart';
import '../../../../domain/entities/user_entity.dart';

abstract class EmailAuthState extends Equatable {
  const EmailAuthState();

  @override
  List<Object?> get props => [];
}

class EmailAuthInitial extends EmailAuthState {
  const EmailAuthInitial();
}

class EmailAuthLoading extends EmailAuthState {
  const EmailAuthLoading();
}

class EmailAuthAuthenticated extends EmailAuthState {
  final UserEntity user;

  const EmailAuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class EmailAuthError extends EmailAuthState {
  final String message;

  const EmailAuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EmailAuthPasswordResetSent extends EmailAuthState {
  final String email;

  const EmailAuthPasswordResetSent({required this.email});

  @override
  List<Object?> get props => [email];
}