import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/auth/presentation/block/auth_bloc.dart';
import 'package:packinn/features/auth/presentation/screens/welcome_screen.dart';
import 'package:packinn/features/hostel_management/presentation/screens/home_screen.dart';
import '../block/auth_event.dart';
import '../block/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
// Wait for Firebase auth state and 3-second delay
    Future.wait([
      FirebaseAuth.instance.authStateChanges().first,
      Future.delayed(const Duration(seconds: 3)),
    ]).then((_) {
      if (mounted) {
        print('SplashScreen: Dispatching CheckAuthStatusEvent');
        context.read<AuthBloc>().add(CheckAuthStatusEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          print('SplashScreen BlocConsumer received state: $state');
          if (state is AuthAuthenticated) {
            print(
                'SplashScreen: Navigating to HomeScreen for user ${state.user.uid}');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else if (state is AuthInitial) {
            print('SplashScreen: Navigating to WelcomeScreen');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false,
            );
          } else if (state is AuthError) {
            print('SplashScreen: Error state received: ${state.message}');
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
            child: Center(
              child: Stack(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset('assets/images/Background.jpg',
                        fit: BoxFit.fill),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/PackInn_l.png',
                      height: 150,
                    ),
                  ),
                  Positioned(
                    top: height * 0.563,
                    left: width * 0.325,
                    child: Text(
                      'PackInn',
                      style: GoogleFonts.zenDots(
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
