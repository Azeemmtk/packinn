import 'package:flutter/material.dart';

class SplashAnimations {
  final AnimationController logoController;
  final AnimationController textController;
  final AnimationController loadingController;

  late Animation<double> logoFade;
  late Animation<double> logoScale;
  late Animation<double> textFade;
  late Animation<Offset> textSlide;
  late Animation<double> loadingFade;

  SplashAnimations({
    required TickerProvider vsync,
  })  : logoController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: vsync,
  ),
        textController = AnimationController(
          duration: const Duration(milliseconds: 1000),
          vsync: vsync,
        ),
        loadingController = AnimationController(
          duration: const Duration(milliseconds: 800),
          vsync: vsync,
        ) {
    logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeInOut),
    );
    logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.elasticOut),
    );
    textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: textController, curve: Curves.easeIn),
    );
    textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: textController, curve: Curves.easeOutCubic),
    );
    loadingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: loadingController, curve: Curves.easeIn),
    );
  }

  void dispose() {
    logoController.dispose();
    textController.dispose();
    loadingController.dispose();
  }
}
