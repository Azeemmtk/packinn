import 'package:flutter_bloc/flutter_bloc.dart';

class SignInState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isSubmitting; // Added isSubmitting flag

  SignInState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isSubmitting = false, // Default to false
  });

  SignInState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isSubmitting,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInState());

  void updateEmail(String email) {
    emit(state.copyWith(email: email, emailError: null));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password, passwordError: null));
  }

  void setSubmitting(bool isSubmitting) {
    emit(state.copyWith(isSubmitting: isSubmitting));
  }

  Map<String, String>? submitForm() {
    String? emailError;
    String? passwordError;

    if (state.email.isEmpty) {
      emailError = 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(state.email)) {
      emailError = 'Invalid email format';
    }
    if (state.password.isEmpty) {
      passwordError = 'Password is required';
    } else if (state.password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    }

    // If any validation fails, update state with errors
    if (emailError != null || passwordError != null) {
      emit(state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        isSubmitting: false, // Reset submitting state
      ));
      return null;
    }

    // Return all form data if validation passes
    return {
      'email': state.email,
      'password': state.password,
    };
  }
}