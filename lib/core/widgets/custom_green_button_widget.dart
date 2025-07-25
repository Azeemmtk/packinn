import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/const.dart';


class CustomGreenButtonWidget extends StatelessWidget {
  const CustomGreenButtonWidget({
    super.key,
    required this.name,
    required this.onPressed
  });

  final String name;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed:onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor, // background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // rounded corners
          ),
        ),
        child: Text(
          name,
          style: TextStyle(fontSize: width * 0.06,fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}