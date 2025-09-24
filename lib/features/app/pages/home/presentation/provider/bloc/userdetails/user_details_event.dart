part of 'user_details_bloc.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchUserDetails extends UserDetailsEvent {
  final String uid;

  const FetchUserDetails(this.uid);

  @override
  List<Object> get props => [uid];
}