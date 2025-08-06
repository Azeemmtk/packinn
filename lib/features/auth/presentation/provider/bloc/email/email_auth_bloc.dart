import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/services/current_user.dart';
import '../../../../domain/usecase/sign_in_with_email.dart';
import '../../../../domain/usecase/sign_up_with_email.dart';
import '../../../../domain/usecase/reset_password.dart';
import 'email_auth_event.dart';
import 'email_auth_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final ResetPassword resetPassword;

  EmailAuthBloc({
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.resetPassword,
  }) : super(const EmailAuthInitial()) {
    on<EmailAuthSignIn>(_onSignInWithEmail);
    on<EmailAuthSignUp>(_onSignUpWithEmail);
    on<EmailAuthSendPasswordReset>(_onSendPasswordReset);
    on<EmailAuthUpdatePassword>(_onUpdatePassword);
    on<EmailAuthReset>(_onReset); // Add reset event handler
  }

  Future<void> _onSignInWithEmail(
      EmailAuthSignIn event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());
    final result = await signInWithEmail(
        SignInParams(email: event.email, password: event.password));
    result.fold(
          (failure) => emit(EmailAuthError(message: failure.message)),
          (user) {
        print('Email sign-in success ${user.email}');
        CurrentUser().uId = user.uid;
        CurrentUser().name = user.name;
        emit(EmailAuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onSignUpWithEmail(
      EmailAuthSignUp event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());
    final result = await signUpWithEmail(SignUpParams(
      email: event.email,
      password: event.password,
      name: event.name,
      phone: event.phone,
    ));
    result.fold(
          (failure) => emit(EmailAuthError(message: failure.message)),
          (user) {
        print('Email signup successful for user: ${user.email}');
        emit(EmailAuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onSendPasswordReset(
      EmailAuthSendPasswordReset event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());
    final result = await resetPassword(ResetPasswordParams(email: event.email));
    result.fold(
          (failure) => emit(EmailAuthError(message: failure.message)),
          (_) => emit(const EmailAuthPasswordResetSent()),
    );
  }

  Future<void> _onUpdatePassword(
      EmailAuthUpdatePassword event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());
    final result = await resetPassword(ResetPasswordParams(
      uid: event.uid,
      newPassword: event.newPassword,
    ));
    result.fold(
          (failure) => emit(EmailAuthError(message: failure.message)),
          (_) => emit(const EmailAuthPasswordUpdated()),
    );
  }

  void _onReset(EmailAuthReset event, Emitter<EmailAuthState> emit) {
    emit(const EmailAuthInitial());
  }
}