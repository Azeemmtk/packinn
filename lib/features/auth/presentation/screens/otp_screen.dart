import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/auth_bloc.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/auth_event.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/auth_state.dart';
import 'package:packinn/features/auth/presentation/provider/cubit/otp_cubit.dart';
import 'package:packinn/features/auth/presentation/provider/cubit/sign_up_cubit.dart';
import 'package:packinn/features/auth/presentation/screens/new_password_screen.dart';
import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:packinn/features/auth/presentation/widgets/otp_input_widget.dart';

class OtpScreen extends StatelessWidget {
  final String status;
  final String verificationId;
  final Map<String, String> data;

  const OtpScreen({
    super.key,
    required this.status,
    required this.verificationId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OtpCubit>(
      create: (context) => getIt<OtpCubit>(),
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated && status == 'FP') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification Successful!')),
              );
            } else if (state is AuthAuthenticated && status == 'RE') {
              print('otpScreen============${data['name']},${data['email']}, ${data['phone']}, ${data['password']}');
              context.read<AuthBloc>().add(
                AuthSignUpWithEmailEvent(
                  name: data['name']!,
                  email: data['email']!,
                  phone: data['phone']!,
                  password: data['password']!,
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen(fromSignUp: true,)),
                    (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Signed up successfully as ${state.user.email}')),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: height,
              width: width,
              child: Column(
                children: [
                  SizedBox(height: height * 0.15),
                  Text(
                    'OTP',
                    style: TextStyle(
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: height * 0.17),
                  Text(
                    'Enter 6-digits code we sent you on your phone number',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: width * 0.05),
                  ),
                  SizedBox(height: height * 0.02),
                  BlocBuilder<SignUpCubit, SignUpState>(
                    bloc: getIt<SignUpCubit>(),
                    builder: (context, state) => Text(
                      state.phone.isNotEmpty ? '+91${state.phone}' : '+79******91',
                      style: TextStyle(
                        fontSize: width * 0.047,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  const OtpInputField(),
                  SizedBox(height: height * 0.08),
                  TextButton(
                    onPressed: () {
                      final signUpState = getIt<SignUpCubit>().state;
                      if (signUpState.phone.isNotEmpty) {
                        context.read<AuthBloc>().add(SendOtpEvent('+91${signUpState.phone}'));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Phone number not available')),
                        );
                      }
                    },
                    child: Text(
                      'Send again',
                      style: TextStyle(
                        color: customGrey,
                        fontSize: width * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.16),
                  BlocBuilder<OtpCubit, String>(
                    builder: (context, otp) {
                      return CustomGreenButtonWidget(
                        name: 'Continue',
                        onPressed: () {
                          print('OTP entered: $otp');
                          if (otp.isNotEmpty) {
                            context.read<AuthBloc>().add(VerifyOtpEvent(verificationId, otp));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter the OTP')),
                            );
                          }
                        },
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: width * 0.045),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}