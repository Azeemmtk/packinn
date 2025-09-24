import 'package:equatable/equatable.dart';
import '../../../../../../core/entity/user_entity.dart';

abstract class GoogleAuthState extends Equatable {
  const GoogleAuthState();

  @override
  List<Object?> get props => [];
}

class GoogleAuthInitial extends GoogleAuthState {
  const GoogleAuthInitial();
}

class GoogleAuthLoading extends GoogleAuthState {
  const GoogleAuthLoading();
}

class GoogleAuthAuthenticated extends GoogleAuthState {
  final UserEntity user;

  const GoogleAuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class GoogleAuthError extends GoogleAuthState {
  final String message;

  const GoogleAuthError({required this.message});

  @override
  List<Object?> get props => [message];
}