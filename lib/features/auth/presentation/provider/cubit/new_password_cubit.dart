import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NewPasswordState extends Equatable {
  const NewPasswordState();

  @override
  List<Object?> get props => [];
}

class NewPasswordInitial extends NewPasswordState {}

class NewPasswordLoading extends NewPasswordState {}

class NewPasswordSuccess extends NewPasswordState {}

class NewPasswordError extends NewPasswordState {
  final String message;

  const NewPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

class NewPasswordValidation extends NewPasswordState {
  final String? newPasswordError;
  final String? repeatPasswordError;
  final bool isValid;

  const NewPasswordValidation({
    this.newPasswordError,
    this.repeatPasswordError,
    this.isValid = false,
  });

  @override
  List<Object?> get props => [newPasswordError, repeatPasswordError, isValid];
}


class NewPasswordCubit extends Cubit<NewPasswordState> {
  NewPasswordCubit() : super(NewPasswordInitial());

  String? _newPassword;
  String? _repeatPassword;

  void updateNewPassword(String password) {
    _newPassword = password;
    _validateForm();
  }

  void updateRepeatPassword(String password) {
    _repeatPassword = password;
    _validateForm();
  }

  void _validateForm() {
    String? newPasswordError;
    String? repeatPasswordError;
    bool isValid = false;

    // Password validation logic
    if (_newPassword == null || _newPassword!.isEmpty) {
      newPasswordError = 'Password cannot be empty';
    } else if (_newPassword!.length < 6) {
      newPasswordError = 'Password must be at least 6 characters';
    }

    if (_repeatPassword == null || _repeatPassword!.isEmpty) {
      repeatPasswordError = 'Please repeat your password';
    } else if (_repeatPassword != _newPassword) {
      repeatPasswordError = 'Passwords do not match';
    }

    // Form is valid if there are no errors
    isValid = newPasswordError == null && repeatPasswordError == null;

    emit(NewPasswordValidation(
      newPasswordError: newPasswordError,
      repeatPasswordError: repeatPasswordError,
      isValid: isValid,
    ));
  }

  void submitNewPassword() async {
    if (state is NewPasswordValidation && (state as NewPasswordValidation).isValid) {
      emit(NewPasswordLoading());
      try {
        // Simulate an API call or password update logic
        await Future.delayed(Duration(seconds: 2)); // Mock async operation
        emit(NewPasswordSuccess());
      } catch (e) {
        emit(NewPasswordError('Failed to update password: $e'));
      }
    }
  }
}