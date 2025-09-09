import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashLoader extends StatelessWidget {
  final Animation<double> fade;
  final bool show;

  const SplashLoader({super.key, required this.fade, required this.show});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: Column(
        children: [
          if (show)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
        ],
      ),
    );
  }
}