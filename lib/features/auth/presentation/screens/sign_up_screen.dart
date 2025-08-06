import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/const.dart';
import '../../../../core/widgets/custom_green_button_widget.dart';
import '../provider/bloc/otp/otp_auth_bloc.dart';
import '../provider/bloc/otp/otp_auth_event.dart';
import '../provider/bloc/otp/otp_auth_state.dart';
import '../provider/cubit/sign_up_cubit.dart';
import '../widgets/curved_container_widget.dart';
import '../widgets/custom_auth_input_widget.dart';
import 'otp_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OtpAuthBloc, OtpAuthState>(
        listener: (context, state) {
          if (state is OtpEmailChecked) {
            if (state.emailExists) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This account is already registered.'),
                ),
              );
            } else {
              // Email doesn't exist, proceed to send OTP
              context.read<OtpAuthBloc>().add(OtpAuthSendOtp('+91${context.read<SignUpCubit>().state.phone}'));
            }
          } else if (state is OtpSent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                  data: {
                    'name': context.read<SignUpCubit>().state.name,
                    'email': context.read<SignUpCubit>().state.email,
                    'phone': context.read<SignUpCubit>().state.phone,
                    'password': context.read<SignUpCubit>().state.password,
                  },
                  status: 'RE',
                  verificationId: state.verificationId,
                ),
              ),
            );
          } else if (state is OtpAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              CurvedContainerWidget(height: height * 0.3, title: 'Sign up'),
              Padding(
                padding: EdgeInsets.all(width * 0.03),
                child: BlocBuilder<SignUpCubit, SignUpState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        CustomAuthInputWidget(
                          title: 'Name',
                          hint: 'Enter name',
                          icon: CupertinoIcons.person,
                          errorText: state.nameError,
                          onChanged: (value) => context.read<SignUpCubit>().updateName(value),
                        ),
                        height10,
                        CustomAuthInputWidget(
                          title: 'Mail',
                          hint: 'demo@gmail.com',
                          icon: CupertinoIcons.mail,
                          errorText: state.emailError,
                          onChanged: (value) => context.read<SignUpCubit>().updateEmail(value),
                        ),
                        height10,
                        CustomAuthInputWidget(
                          title: 'Phone',
                          hint: '7994042391',
                          isNum: true,
                          icon: FontAwesomeIcons.mobileScreen,
                          errorText: state.phoneError,
                          onChanged: (value) => context.read<SignUpCubit>().updatePhone(value),
                        ),
                        height10,
                        CustomAuthInputWidget(
                          title: 'Password',
                          hint: 'Enter password',
                          icon: CupertinoIcons.lock,
                          isSecure: true,
                          errorText: state.passwordError,
                          onChanged: (value) => context.read<SignUpCubit>().updatePassword(value),
                        ),
                        height10,
                        CustomAuthInputWidget(
                          title: 'Confirm password',
                          hint: 'Repeat password',
                          icon: CupertinoIcons.lock,
                          isSecure: true,
                          errorText: state.confirmPasswordError,
                          onChanged: (value) => context.read<SignUpCubit>().updateConfirmPassword(value),
                        ),
                        SizedBox(height: height * 0.06),
                        CustomGreenButtonWidget(
                          name: 'Create account',
                          onPressed: state.nameError != null ||
                              state.emailError != null ||
                              state.phoneError != null ||
                              state.passwordError != null ||
                              state.confirmPasswordError != null
                              ? null
                              : () {
                            final formData = context.read<SignUpCubit>().submitForm();
                            if (formData != null) {
                              context.read<OtpAuthBloc>().add(OtpAuthCheckEmail(formData['email']!));
                            }
                          },
                          isLoading: context.watch<OtpAuthBloc>().state is OtpAuthLoading,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account ? ',
                              style: TextStyle(fontSize: width * 0.042),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: width * 0.042,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}