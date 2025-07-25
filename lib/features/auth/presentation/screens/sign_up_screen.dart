import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/features/auth/presentation/screens/otp_screen.dart';
import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:packinn/features/auth/presentation/widgets/curved_container_widget.dart';
import 'package:packinn/features/auth/presentation/widgets/custom_auth_input_widget.dart';

import '../../../../core/constants/colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedContainerWidget(height: height * 0.33, title: 'Sign up'),
            Padding(
              padding: EdgeInsets.all(
                width * 0.03,
              ),
              child: Column(
                children: [
                  CustomAuthInputWidget(
                      title: 'Name',
                      initial: 'Enter name',
                      icon: CupertinoIcons.person),
                  height10,
                  CustomAuthInputWidget(
                      title: 'Mail',
                      initial: 'demo@gmail.com',
                      icon: CupertinoIcons.mail),
                  height10,
                  CustomAuthInputWidget(
                      title: 'Phone',
                      initial: '1234567890',
                      icon: FontAwesomeIcons.mobileScreen),
                  height10,
                  CustomAuthInputWidget(
                    title: 'Password',
                    initial: 'Enter password',
                    icon: CupertinoIcons.lock,
                    isSecure: true,
                  ),
                  height10,
                  CustomAuthInputWidget(
                    title: 'Confirm password',
                    initial: 'Repeat password',
                    icon: CupertinoIcons.lock,
                    isSecure: true,
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  CustomGreenButtonWidget(
                    name: 'Create account',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(status: 'RE',),
                          ));
                    },
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
                              ));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: width * 0.042,
                              fontWeight: FontWeight.bold,
                              color: mainColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
