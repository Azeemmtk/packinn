import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/services/current_user.dart';
import '../../../../domain/usecase/google_sign_in.dart';
import 'google_auth_event.dart';
import 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final GoogleSignIn googleSignIn;

  GoogleAuthBloc({required this.googleSignIn})
      : super(const GoogleAuthInitial()) {
    on<GoogleAuthSignIn>(_onSignInWithGoogle);
  }

  Future<void> _onSignInWithGoogle(
      GoogleAuthSignIn event, Emitter<GoogleAuthState> emit) async {
    emit(const GoogleAuthLoading());
    final result = await googleSignIn();
    result.fold(
          (failure) => emit(GoogleAuthError(message: failure.message)),
          (user) {
            CurrentUser().name = user.name;
            CurrentUser().uId = user.uid;
            emit(GoogleAuthAuthenticated(user: user));
          },
    );
  }
}