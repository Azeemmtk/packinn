import 'package:flutter/material.dart';
import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';

import '../../../../core/constants/const.dart';
import '../../../../core/widgets/custom_green_button_widget.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * 0.3,
          ),
          Text(
            'Setup new password',
            style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          height10,
          Text('Please, setup a new password for your account',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.05,
            ),
          ),
          height20,
          CustomTextFieldWidget(text: 'New Password',isSecure: true,),
          height10,
          CustomTextFieldWidget(text: 'Repeat Password',isSecure: true,),
          Spacer(),
          CustomGreenButtonWidget(
            name: 'Goto Sign in',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen(),));
            },
          ),
          TextButton(onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen(),), (route) => false,);
          }, child: Text('Cancel',style: TextStyle(
            fontSize: width * 0.045,
          ),)),
        ],
      ),
    );
  }
}
