import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/auth/presentation/screens/welcome_screen.dart';
import '../../../app/main_screen/presentation/screen/main_screen.dart';
import '../provider/bloc/auth_bloc.dart';
import '../provider/bloc/email/email_auth_state.dart';
import '../widgets/splash_screen/splash_animation.dart';
import '../widgets/splash_screen/splash_loader.dart';
import '../widgets/splash_screen/splash_logo.dart';
import '../widgets/splash_screen/splash_subtitle.dart';
import '../widgets/splash_screen/splash_title.dart';
import '../widgets/splash_screen/splash_version.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late SplashAnimations _animations;

  @override
  void initState() {
    super.initState();
    _animations = SplashAnimations(vsync: this);

    // Delay & check authentication
    Future.wait([
      FirebaseAuth.instance.authStateChanges().first,
      Future.delayed(const Duration(seconds: 4)),
    ]).then((_) {
      if (mounted) {
        context.read<AuthBloc>().add(CheckAuthStatusEvent());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getSize(context);
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    _animations.logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) _animations.textController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) _animations.loadingController.forward();
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getSize(context);
    return Scaffold(
      body: BlocConsumer<AuthBloc, dynamic>(
        listener: (context, state) {
          if (state is EmailAuthAuthenticated && mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
            );
          } else if (state is EmailAuthInitial && mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  (route) => false,
            );
          } else if (state is EmailAuthError && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  (route) => false,
            );
          }
        },
        builder: (context, state) {
          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                // Background
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        // 'assets/images/Background.jpg',
                        // fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                          // gradient: LinearGradient(
                          //   begin: Alignment.topCenter,
                          //   end: Alignment.bottomCenter,
                          //   colors: [
                          //     Colors.black.withOpacity(0.1),
                          //     Colors.black.withOpacity(0.3),
                          //   ],
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Center content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SplashLogo(
                        fade: _animations.logoFade,
                        scale: _animations.logoScale,
                      ),
                      const SizedBox(height: 20),
                      SplashTitle(
                        fade: _animations.textFade,
                        slide: _animations.textSlide,
                      ),
                      const SizedBox(height: 10),
                      SplashSubtitle(fade: _animations.textFade),
                      const SizedBox(height: 30),
                      SplashLoader(
                        fade: _animations.loadingFade,
                        show: state is EmailAuthLoading,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                // Version
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: SplashVersion(fade: _animations.textFade),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
