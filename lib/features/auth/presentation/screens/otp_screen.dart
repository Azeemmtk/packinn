import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/email/email_auth_bloc.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/email/email_auth_event.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/otp/otp_auth_bloc.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/otp/otp_auth_event.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/otp/otp_auth_state.dart';
import 'package:packinn/features/auth/presentation/provider/cubit/otp_cubit.dart';
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
    // Safely access phone number with fallback
    final phoneNumber = data['phone']?.isNotEmpty == true ? '+91${data['phone']}' : '+79******91';

    return BlocProvider<OtpCubit>(
      create: (context) => getIt<OtpCubit>(),
      child: Scaffold(
        body: BlocListener<OtpAuthBloc, OtpAuthState>(
          listener: (context, state) {
            if (state is OtpAuthAuthenticated && status == 'FP') {
              // For forgot password, navigate to NewPasswordScreen with only uid
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPasswordScreen(
                    uid: state.user.uid,
                  ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification Successful!')),
              );
            } else if (state is OtpAuthAuthenticated && status == 'RE') {
              // For registration, proceed with signup
              print(
                  'otpScreen============${data['name']},${data['email']}, ${data['phone']}, ${data['password']}');
              context.read<EmailAuthBloc>().add(
                EmailAuthSignUp(
                  name: data['name'] ?? '',
                  email: data['email'] ?? '',
                  phone: data['phone'] ?? '',
                  password: data['password'] ?? '',
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignInScreen(fromSignUp: true)),
                    (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                    Text('Signed up successfully as ${state.user.email}')),
              );
            } else if (state is OtpAuthError) {
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
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      fontSize: width * 0.047,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  const OtpInputField(),
                  SizedBox(height: height * 0.08),
                  TextButton(
                    onPressed: () {
                      if (data['phone']?.isNotEmpty == true) {
                        context
                            .read<OtpAuthBloc>()
                            .add(OtpAuthSendOtp('+91${data['phone']}'));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Phone number not available')),
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
                            context
                                .read<OtpAuthBloc>()
                                .add(OtpAuthVerifyOtp(verificationId, otp));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter the OTP')),
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