import 'package:flutter/material.dart';

import '../constants/colors.dart';

class DetailsRowWidget extends StatelessWidget {
  const DetailsRowWidget({super.key, required this.title, required this.value, this.isBold= false});

  final String title;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isBold ? FontWeight.bold : null,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: headingTextColor,
            fontWeight: isBold ? FontWeight.bold : null,
          ),
        ),
      ],
    );;
  }
}
