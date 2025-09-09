import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashTitle extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;

  const SplashTitle({super.key, required this.fade, required this.slide});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: fade,
        child: Text(
          'PackInn',
          style: GoogleFonts.zenDots(
            textStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.08,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
