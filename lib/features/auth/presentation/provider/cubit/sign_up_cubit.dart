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
    emit(state.copyWith(
      name: name,
      nameError: _validateName(name),
    ));
  }

  void updateEmail(String email) {
    emit(state.copyWith(
      email: email,
      emailError: _validateEmail(email),
    ));
  }

  void updatePhone(String phone) {
    emit(state.copyWith(
      phone: phone,
      phoneError: _validatePhone(phone),
    ));
  }

  void updatePassword(String password) {
    emit(state.copyWith(
      password: password,
      passwordError: _validatePassword(password),
      confirmPasswordError: _validateConfirmPassword(password, state.confirmPassword),
    ));
  }

  void updateConfirmPassword(String confirmPassword) {
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      confirmPasswordError: _validateConfirmPassword(state.password, confirmPassword),
    ));
  }

  // Validation methods
  String? _validateName(String name) {
    if (name.isEmpty) return 'Name is required';
    return null;
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) return 'Invalid email format';
    return null;
  }

  String? _validatePhone(String phone) {
    if (phone.isEmpty) return 'Phone number is required';
    if (phone.length < 10) return 'Phone number must be at least 10 digits';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return 'Confirm password is required';
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }

  Map<String, String>? submitForm() {
    // Re-validate all fields to ensure consistency
    final nameError = _validateName(state.name);
    final emailError = _validateEmail(state.email);
    final phoneError = _validatePhone(state.phone);
    final passwordError = _validatePassword(state.password);
    final confirmPasswordError = _validateConfirmPassword(state.password, state.confirmPassword);

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