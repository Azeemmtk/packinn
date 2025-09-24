import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:packinn/core/constants/colors.dart';

class SplashVersion extends StatelessWidget {
  final Animation<double> fade;

  const SplashVersion({super.key, required this.fade});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: Text(
        'Version 1.0.0',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: mainColor,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}