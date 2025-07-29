import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpState {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String? nameError;
  final String? emailError;
  final String? phoneError;
  final String? passwordError;
  final String? confirmPasswordError;

  SignUpState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.nameError,
    this.emailError,
    this.phoneError,
    this.passwordError,
    this.confirmPasswordError,
  });

  SignUpState copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    String? nameError,
    String? emailError,
    String? phoneError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nameError: nameError,
      emailError: emailError,
      phoneError: phoneError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    );
  }
}

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpState());

  void updateName(String name) {
    emit(state.copyWith(name: name, nameError: null));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email, emailError: null));
  }

  void updatePhone(String phone) {
    emit(state.copyWith(phone: phone, phoneError: null));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password, passwordError: null));
  }

  void updateConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword, confirmPasswordError: null));
  }

  Map<String, String>? submitForm() {
    String? nameError;
    String? emailError;
    String? phoneError;
    String? passwordError;
    String? confirmPasswordError;

    // Validate each field
    if (state.name.isEmpty) {
      nameError = 'Name is required';
    }
    if (state.email.isEmpty) {
      emailError = 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(state.email)) {
      emailError = 'Invalid email format';
    }
    if (state.phone.isEmpty) {
      phoneError = 'Phone number is required';
    } else if (state.phone.length < 10) {
      phoneError = 'Phone number must be at least 10 digits';
    }
    if (state.password.isEmpty) {
      passwordError = 'Password is required';
    } else if (state.password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    }
    if (state.confirmPassword.isEmpty) {
      confirmPasswordError = 'Confirm password is required';
    } else if (state.password != state.confirmPassword) {
      confirmPasswordError = 'Passwords do not match';
    }

    // If any validation fails, update state with errors
    if (nameError != null ||
        emailError != null ||
        phoneError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      emit(state.copyWith(
        nameError: nameError,
        emailError: emailError,
        phoneError: phoneError,
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
      ));
      return null;
    }

    // Return all form data if validation passes
    return {
      'name': state.name,
      'email': state.email,
      'phone': state.phone,
      'password': state.password,
      'confirmPassword': state.confirmPassword,
    };
  }
}