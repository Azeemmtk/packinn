import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';

import '../../../hostel_management/presentation/screens/home_screen.dart';
import '../widgets/otp_input_widget.dart';
import 'new_password_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.15,
              ),
              Text(
                'OTP',
                style: TextStyle(
                    fontSize: width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: height * 0.17,
              ),
              Text('Enter 4-digits code we sent you on your phone number',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: width * 0.05,
                    ),
              ),
              height20,
              Text('+79******91',
                style: TextStyle(
                    fontSize: width * 0.047,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              height20,
              OTPInputWidget(),
              SizedBox(
                height: height * 0.08,
              ),
              TextButton(onPressed: () {

              },
                  child: Text('Send again',
                    style: TextStyle(
                      color: customGrey,
                      fontSize: width * 0.05,
                    ),
                  ),),
              SizedBox(
                height: height * 0.16,
              ),
              CustomGreenButtonWidget(
                name: 'Continue',
                onPressed: () {
                  status=='FP'
                   ? Navigator.push(context, MaterialPageRoute(builder: (context) => NewPasswordScreen(),))
                      : status=='LO'
                      ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false,)
                      : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen(),), (route) => false,);
                },
              ),
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('Cancel',style: TextStyle(
                fontSize: width * 0.045,
              ),)),
            ],
          ),
        ),
      ),
    );
  }
}