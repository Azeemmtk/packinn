import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/auth_bloc.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/auth_event.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/auth_state.dart';
import 'package:packinn/features/auth/presentation/screens/otp_screen.dart';
import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:packinn/features/auth/presentation/widgets/curved_container_widget.dart';
import 'package:packinn/features/auth/presentation/widgets/custom_auth_input_widget.dart';
import 'package:packinn/core/constants/colors.dart';

import '../provider/cubit/sign_up_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignUpCubit>(),
      child: Scaffold(
        body: BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  CurvedContainerWidget(height: height * 0.3, title: 'Sign up'),
                  Padding(
                    padding: EdgeInsets.all(width * 0.03),
                    child: Column(
                      children: [
                        CustomAuthInputWidget(
                          title: 'Name',
                          hint: 'Enter name',
                          icon: CupertinoIcons.person,
                          onChanged: (value) =>
                              context.read<SignUpCubit>().updateName(value),
                          errorText: state.nameError,
                        ),
                        height10,
                        CustomAuthInputWidget(
                          title: 'Mail',
                          hint: 'demo@gmail.com',
                          icon: CupertinoIcons.mail,
                          onChanged: (value) =>
                              context.read<SignUpCubit>().updateEmail(value),
                          errorText: state.emailError,
                        ),
                        height10,
                        CustomAuthInputWidget(
                          title: 'Phone',
                          hint: '7994042391',
                          isNum: true,
                          icon: FontAwesomeIcons.mobileScreen,
                          onChanged: (value) =>
                              context.read<SignUpCubit>().updatePhone(value),
                          errorText: state.phoneError,
                        ),
                        height10,
                        CustomAuthInputWidget(
                          title: 'Password',
                          hint: 'Enter password',
                          icon: CupertinoIcons.lock,
                          isSecure: true,
                          onChanged: (value) =>
                              context.read<SignUpCubit>().updatePassword(value),
                          errorText: state.passwordError,
                        ),
                        height10,
                        CustomAuthInputWidget(
                          title: 'Confirm password',
                          hint: 'Repeat password',
                          icon: CupertinoIcons.lock,
                          isSecure: true,
                          onChanged: (value) => context
                              .read<SignUpCubit>()
                              .updateConfirmPassword(value),
                          errorText: state.confirmPasswordError,
                        ),
                        SizedBox(
                          height: height * 0.06,
                        ),
                        BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) {
                            final data= context.read<SignUpCubit>().submitForm();
                            print(data);
                            if (state is OtpSent) {
                              print('=====================${state.verificationId}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpScreen(
                                    data: data!,
                                    status: 'RE',
                                    verificationId: state.verificationId,
                                  ),
                                ),
                              );
                            }else if(state is AuthError){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                          child: CustomGreenButtonWidget(
                            name: 'Create account',
                            onPressed: () {
                              final data = context.read<SignUpCubit>().submitForm();
                              print(data?['phone']);
                              if(data != null){
                                context.read<AuthBloc>().add(SendOtpEvent('+91${data['phone']!}'));
                              }
                            },
                          ),
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
                                    builder: (context) => SignInScreen(),
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
