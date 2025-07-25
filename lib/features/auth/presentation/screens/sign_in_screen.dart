import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/auth/presentation/block/auth_bloc.dart';
import 'package:packinn/features/auth/presentation/screens/otp_screen.dart';
import 'package:packinn/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:packinn/features/auth/presentation/widgets/curved_container_widget.dart';
import 'package:packinn/features/hostel_management/presentation/screens/home_screen.dart';
import '../../../../core/widgets/custom_green_button_widget.dart';
import '../block/auth_state.dart';
import '../widgets/custom_auth_input_widget.dart';
import '../widgets/google_sign_in_button_widget.dart';
import '../widgets/remember_forgot_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          print('SignInScreen BlocConsumer received state: $state'); // Debug print
          if (state is AuthAuthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CurvedContainerWidget(height: 400, title: 'Sign In'),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      CustomAuthInputWidget(
                        title: 'Phone',
                        initial: '1234567890',
                        icon: FontAwesomeIcons.mobileScreen,
                      ),
                      height10,
                      CustomAuthInputWidget(
                        title: 'Password',
                        initial: 'Enter password',
                        isSecure: true,
                        icon: CupertinoIcons.lock,
                      ),
                      RememberForgotWidget(),
                      height10,
                      CustomGreenButtonWidget(
                        name: 'Login',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OtpScreen(status: 'Lo')),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account ? ',
                            style: TextStyle(fontSize: width * 0.042),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: width * 0.042,
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      height20,
                      height20,
                      height20,
                      GoogleSignInButtonWidget(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}