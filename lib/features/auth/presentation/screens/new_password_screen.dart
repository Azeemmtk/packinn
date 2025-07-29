import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';

import '../../../../core/constants/const.dart';
import '../../../../core/widgets/custom_green_button_widget.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../provider/cubit/new_password_cubit.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPasswordCubit(),
      child: Scaffold(
        body: BlocConsumer<NewPasswordCubit, NewPasswordState>(
          listener: (context, state) {
            if (state is NewPasswordSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
                    (route) => false,
              );
            } else if (state is NewPasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            bool isLoading = state is NewPasswordLoading;
            String? newPasswordError;
            String? repeatPasswordError;
            bool isButtonEnabled = false;

            if (state is NewPasswordValidation) {
              newPasswordError = state.newPasswordError;
              repeatPasswordError = state.repeatPasswordError;
              isButtonEnabled = state.isValid;
            }

            return Column(
              children: [
                SizedBox(height: height * 0.3),
                Text(
                  'Setup new password',
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  'Please, setup a new password for your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: width * 0.05),
                ),
                SizedBox(height: height * 0.02),
                CustomTextFieldWidget(
                  text: 'New Password',
                  isSecure: true,
                  errorText: newPasswordError,
                  onChanged: (value) {
                    context.read<NewPasswordCubit>().updateNewPassword(value);
                  },
                ),
                SizedBox(height: height * 0.01),
                CustomTextFieldWidget(
                  text: 'Repeat Password',
                  isSecure: true,
                  errorText: repeatPasswordError,
                  onChanged: (value) {
                    context.read<NewPasswordCubit>().updateRepeatPassword(value);
                  },
                ),
                Spacer(),
                CustomGreenButtonWidget(
                  name: isLoading ? 'Processing...' : 'Goto Sign in',
                  onPressed: isLoading || !isButtonEnabled
                      ? null
                      : () {
                    context.read<NewPasswordCubit>().submitNewPassword();
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                          (route) => false,
                    );
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: width * 0.045),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}