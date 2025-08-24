import 'package:equatable/equatable.dart';

abstract class GoogleAuthEvent extends Equatable {
  const GoogleAuthEvent();

  @override
  List<Object?> get props => [];
}

class GoogleAuthSignIn extends GoogleAuthEvent {
  const GoogleAuthSignIn();
}