import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';

class SplashLoader extends StatelessWidget {
  final Animation<double> fade;
  final bool show;

  const SplashLoader({super.key, required this.fade, required this.show});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.1,
      child: FadeTransition(
        opacity: fade,
        child: Column(
          children: [
            if (show)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            if (show) const SizedBox(height: 10),
            if (show)
              Text(
                'Initializing...',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    color: mainColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}