import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/app/Navigation/presentation/screen/main_screen.dart';
import 'package:packinn/features/auth/presentation/screens/sign_up_screen.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_green_button_widget.dart';
import '../../../app/pages/home/presentation/screen/home_screen.dart';
import '../provider/bloc/email/email_auth_bloc.dart';
import '../provider/bloc/email/email_auth_event.dart';
import '../provider/bloc/email/email_auth_state.dart';
import '../provider/bloc/google/google_auth_bloc.dart';
import '../provider/bloc/google/google_auth_state.dart';
import '../widgets/curved_container_widget.dart';
import '../widgets/custom_auth_input_widget.dart';
import '../widgets/google_sign_in_button_widget.dart';
import '../widgets/remember_forgot_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.fromSignUp = false});
  final bool fromSignUp;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      _emailError = Validation.validateEmail(_emailController.text);
      _passwordError = Validation.validatePassword(_passwordController.text);
      _isSubmitting = _emailError == null && _passwordError == null;
    });

    if (_isSubmitting) {
      context.read<EmailAuthBloc>().add(
        EmailAuthSignIn(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<EmailAuthBloc, EmailAuthState>(
            listener: (context, state) {
              print('SignInScreen EmailAuthBloc received state: $state');
              if (state is EmailAuthAuthenticated && _isSubmitting) {
                print('Navigating to HomeScreen');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                      (route) => false,
                );
                if (widget.fromSignUp) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: mainColor,
                      content: const Text(
                        'Signed up successfully! You are now logged in.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                }
              } else if (state is EmailAuthError) {
                setState(() {
                  _isSubmitting = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: mainColor,
                    content: Text(
                      state.message,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<GoogleAuthBloc, GoogleAuthState>(
            listener: (context, state) {
              print('SignInScreen GoogleAuthBloc received state: $state');
              if (state is GoogleAuthAuthenticated) {
                print('Navigating to HomeScreen');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                      (route) => false,
                );
              } else if (state is GoogleAuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: mainColor,
                    content: Text(
                      state.message,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CurvedContainerWidget(height: 400, title: 'Sign In'),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    CustomAuthInputWidget(
                      title: 'Email',
                      hint: 'demo@gmail.com',
                      icon: CupertinoIcons.mail,
                      controller: _emailController,
                      errorText: _emailError,
                      onChanged: (value) {
                        setState(() {
                          _emailError = Validation.validateEmail(value);
                        });
                      },
                    ),
                    height10,
                    CustomAuthInputWidget(
                      title: 'Password',
                      hint: 'Enter password',
                      isSecure: true,
                      icon: CupertinoIcons.lock,
                      controller: _passwordController,
                      errorText: _passwordError,
                      onChanged: (value) {
                        setState(() {
                          _passwordError = Validation.validatePassword(value);
                        });
                      },
                    ),
                    const RememberForgotWidget(),
                    height10,
                    CustomGreenButtonWidget(
                      name: 'Login',
                      onPressed: _isSubmitting ? null : _validateAndSubmit,
                      isLoading: _isSubmitting,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account ? ',
                          style: TextStyle(fontSize: width * 0.042),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: width * 0.042,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height20,
                    height20,
                    GoogleSignInButtonWidget(
                      isLoading: context.watch<GoogleAuthBloc>().state is GoogleAuthLoading,
                      child: context.watch<GoogleAuthBloc>().state is GoogleAuthLoading
                          ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}