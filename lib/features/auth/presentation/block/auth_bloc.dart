import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/features/auth/domain/usecase/google_sign_in.dart';
import 'package:packinn/features/auth/domain/usecase/sign_out.dart';
import 'package:packinn/features/auth/presentation/block/auth_event.dart';
import 'package:packinn/features/auth/presentation/block/auth_state.dart';
import '../../domain/usecase/check_auth_status.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GoogleSignIn googleSignIn;
  final SignOut signOut;
  final CheckAuthStatus checkAuthStatus;
  final FirebaseAuth firebaseAuth;

  AuthBloc({
    required this.googleSignIn,
    required this.signOut,
    required this.firebaseAuth,
    required this.checkAuthStatus,
  }) : super(AuthInitial()) {
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<SignOutEvent>(_onSignOut);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await googleSignIn();
      if (user != null) {
        print('Emitting AuthAuthenticated with user: ${user.uid}');
        emit(AuthAuthenticated(user));
      } else {
        print('Emitting AuthError: Google Sign-In cancelled');
        emit(const AuthError('Google Sign-In cancelled'));
      }
    } catch (e) {
      print('Emitting AuthError: Google Sign-In failed: $e');
      emit(AuthError('Google Sign-In failed: $e'));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    if (firebaseAuth.currentUser == null) {
      print('No user signed in, emitting AuthInitial');
      emit(AuthInitial());
      return;
    }
    emit(AuthLoading());
    try {
      await signOut();
      print('Emitting AuthInitial after sign out');
      emit(AuthInitial());
    } catch (e) {
      print('Emitting AuthError: Sign out failed: $e');
      emit(AuthError('Sign out failed: $e'));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await checkAuthStatus();
      if (user != null) {
        print('Emitting AuthAuthenticated with user: ${user.uid}');
        emit(AuthAuthenticated(user));
      } else {
        print('Emitting AuthInitial: No authenticated user');
        emit(AuthInitial());
      }
    } catch (e) {
      print('Emitting AuthError: Check auth status failed: $e');
      emit(AuthError('Check auth status failed: $e'));
    }
  }
}
