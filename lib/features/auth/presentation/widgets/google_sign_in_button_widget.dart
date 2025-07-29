import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import '../provider/bloc/auth_bloc.dart';
import '../provider/bloc/auth_event.dart';

class GoogleSignInButtonWidget extends StatelessWidget {
  final bool isLoading;
  final Widget? child;

  const GoogleSignInButtonWidget({
    super.key,
    this.isLoading = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
          context.read<AuthBloc>().add(const AuthSignInWithGoogleEvent());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/google_icon.png',
                    height: width * 0.07),
                width10,
                Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}