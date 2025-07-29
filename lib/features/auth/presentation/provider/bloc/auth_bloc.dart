import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/features/auth/domain/usecase/send-otp.dart';
import 'package:packinn/features/auth/domain/usecase/verify_otp.dart';
import '../../../domain/usecase/check_auth_status.dart';
import '../../../domain/usecase/google_sign_in.dart';
import '../../../domain/usecase/sign_in_with_email.dart';
import '../../../domain/usecase/sign_out.dart';
import '../../../domain/usecase/sign_up_with_email.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatus checkAuthStatus;
  final GoogleSignIn googleSignIn;
  final SignOut signOut;
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  AuthBloc({
    required this.checkAuthStatus,
    required this.googleSignIn,
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signOut,
    required this.verifyOtp,
    required this.sendOtp,
  }) : super(const AuthInitial()) {
    on<AuthCheckStatusEvent>(_onCheckAuthStatus);
    on<AuthSignInWithGoogleEvent>(_onSignInWithGoogle);
    on<AuthSignInWithEmailEvent>(_onSignInWithEmail);
    on<AuthSignUpWithEmailEvent>(_onSignUpWithEmail);
    on<AuthSignOutEvent>(_onSignOut);
    on<SendOtpEvent>(_sendOtp);
    on<VerifyOtpEvent>(_verifyOtp);
  }

  Future<void> _onCheckAuthStatus(
      AuthCheckStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthEmailLoading());

    final result = await checkAuthStatus();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user, authMethod: 'unknown'));
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
    emit(const AuthGoogleLoading());

    final result = await googleSignIn();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user, authMethod: 'google')),
    );
  }

  Future<void> _onSignOut(
      AuthSignOutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthGoogleLoading());

    final result = await signOut();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _sendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthOtpLoading());
    final result = await sendOtp(event.phoneNumber);
    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (verificationId) => emit(OtpSent(verificationId)),
    );
  }

  Future<void> _verifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthOtpLoading());

    final result = await verifyOtp(
        VerifyOtpParams(verificationId: event.verificationId, otp: event.otp));
    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (authResult) {
        if (authResult.phoneVerified) {
          emit(AuthAuthenticated(user: authResult, authMethod: 'phone'));
        } else {
          emit(const AuthError(message: 'Verification failed'));
        }
      },
    );
  }

  Future<void> _onSignInWithEmail(
      AuthSignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(const AuthEmailLoading());
    final result = await signInWithEmail(
        SignInParams(email: event.email, password: event.password));
    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) {
        print('Email sign-in success ${user.email}');
        emit(AuthAuthenticated(user: user, authMethod: 'email'));
      },
    );
  }

  Future<void> _onSignUpWithEmail(
      AuthSignUpWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(const AuthEmailLoading());
    final result = await signUpWithEmail(SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
        phone: event.phone));
    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) {
        print('Email signup successful for user: ${user.email}');
        emit(AuthAuthenticated(user: user, authMethod: 'email'));
      },
    );
  }
}