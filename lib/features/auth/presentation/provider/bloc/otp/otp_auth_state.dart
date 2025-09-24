import 'package:equatable/equatable.dart';
import '../../../../../../core/entity/user_entity.dart';

abstract class OtpAuthState extends Equatable {
  const OtpAuthState();

  @override
  List<Object?> get props => [];
}

class OtpAuthInitial extends OtpAuthState {
  const OtpAuthInitial();
}

class OtpAuthLoading extends OtpAuthState {
  const OtpAuthLoading();
}

class OtpSent extends OtpAuthState {
  final String verificationId;

  const OtpSent(this.verificationId);

  @override
  List<Object?> get props => [verificationId];
}

class OtpAuthAuthenticated extends OtpAuthState {
  final UserEntity user;

  const OtpAuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class OtpAuthError extends OtpAuthState {
  final String message;

  const OtpAuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OtpEmailChecked extends OtpAuthState {
  final bool emailExists;

  const OtpEmailChecked({required this.emailExists});

  @override
  List<Object?> get props => [emailExists];
}