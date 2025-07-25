import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/const.dart';
import '../screens/otp_screen.dart';

class RememberForgotWidget extends StatefulWidget {
  const RememberForgotWidget({
    super.key,
  });

  @override
  State<RememberForgotWidget> createState() => _RememberForgotWidgetState();
}

class _RememberForgotWidgetState extends State<RememberForgotWidget> {

  bool isCheck= false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: mainColor,
          value: isCheck,
          onChanged: (value) {
            setState(() {
              isCheck = !isCheck;
            });
          },
        ),
        Text('Remember Me',style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: width * 0.039,
            color: Colors.black
        ),),
        Spacer(),
        TextButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(status: 'FP',),));
        }, child: Text('Forgot password?',style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: width * 0.041,
            color: mainColor
        ),),)
      ],
    );
  }
}
