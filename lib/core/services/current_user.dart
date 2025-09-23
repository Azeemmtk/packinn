import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();

  factory CurrentUser() => _instance;

  CurrentUser._internal();

  String? uId;
  String? name;
}

final currentUserName= FirebaseAuth.instance.currentUser?.displayName ?? 'no name';
