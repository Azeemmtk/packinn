part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfileEvent extends EditProfileEvent {
  final UserModel user;

  const UpdateProfileEvent(this.user);

  @override
  List<Object> get props => [user];
}