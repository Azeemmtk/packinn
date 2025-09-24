import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:packinn/core/constants/colors.dart';

class SplashSubtitle extends StatelessWidget {
  final Animation<double> fade;
  const SplashSubtitle({super.key, required this.fade});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: Text(
        'Find Your Perfect Stay',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.045,
            color: mainColor,
            fontWeight: FontWeight.w300,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
