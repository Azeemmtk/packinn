import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/check_auth_status.dart';
import '../../domain/usecase/google_sign_in.dart';
import '../../domain/usecase/sign_in_with_email.dart';
import '../../domain/usecase/sign_out.dart';
import '../../domain/usecase/sign_up_with_email.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatus checkAuthStatus;
  final GoogleSignIn googleSignIn;
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignOut signOut;

  AuthBloc({
    required this.checkAuthStatus,
    required this.googleSignIn,
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signOut,
  }) : super(const AuthInitial()) {
    on<AuthCheckStatusEvent>(_onCheckAuthStatus);
    on<AuthSignInWithGoogleEvent>(_onSignInWithGoogle);
    on<AuthSignInWithEmailEvent>(_onSignInWithEmail);
    on<AuthSignUpWithEmailEvent>(_onSignUpWithEmail);
    on<AuthSignOutEvent>(_onSignOut);
  }

  Future<void> _onCheckAuthStatus(
      AuthCheckStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await checkAuthStatus();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInWithGoogle(
      AuthSignInWithGoogleEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await googleSignIn();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignInWithEmail(
      AuthSignInWithEmailEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signInWithEmail(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignUpWithEmail(
      AuthSignUpWithEmailEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signUpWithEmail(
      SignUpParams(email: event.email, password: event.password),
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignOut(
      AuthSignOutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signOut();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (_) => emit(const AuthUnauthenticated()),
    );
  }
}
