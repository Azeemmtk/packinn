import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/auth/presentation/provider/cubit/sign_in_cubit.dart';
import 'package:packinn/features/auth/presentation/screens/otp_screen.dart';
import 'package:packinn/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:packinn/features/hostel_management/presentation/screens/home_screen.dart';
import '../../../../core/widgets/custom_green_button_widget.dart';
import '../provider/bloc/auth_bloc.dart';
import '../provider/bloc/auth_event.dart';
import '../provider/bloc/auth_state.dart';
import '../widgets/curved_container_widget.dart';
import '../widgets/custom_auth_input_widget.dart';
import '../widgets/google_sign_in_button_widget.dart';
import '../widgets/remember_forgot_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, this.fromSignUp = false});
  final bool fromSignUp;

  @override
  Widget build(BuildContext context) {
    // Dispatch AuthCheckStatusEvent only if not from signup
    // if (!fromSignUp) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     print('Dispatching AuthCheckStatusEvent');
    //     context.read<AuthBloc>().add(AuthCheckStatusEvent());
    //   });
    // }

    return Scaffold(
      body: BlocProvider(
        create: (context) => SignInCubit(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            print('SignInScreen BlocConsumer received state: $state');
            final isSubmitting = context.read<SignInCubit>().state.isSubmitting;
            if (state is AuthAuthenticated && state.authMethod != 'phone') {
              // Navigate if not from signup or if it's a manual email login
              if (!fromSignUp || (state.authMethod == 'email' && isSubmitting)) {
                print('Navigating to HomeScreen');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                );
              }
            } else if (state is AuthError) {
              // Reset isSubmitting on error
              context.read<SignInCubit>().setSubmitting(false);
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
          builder: (context, state) {
            // Only show loading indicator for manual email login
            final isEmailLoading = state is AuthEmailLoading && context.read<SignInCubit>().state.isSubmitting;
            final isGoogleLoading = state is AuthGoogleLoading;
            return SingleChildScrollView(
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
                          onChanged: (value) => context.read<SignInCubit>().updateEmail(value),
                          errorText: context.read<SignInCubit>().state.emailError,
                        ),
                        height10,
                        CustomAuthInputWidget(
                          title: 'Password',
                          hint: 'Enter password',
                          isSecure: true,
                          icon: CupertinoIcons.lock,
                          onChanged: (value) => context.read<SignInCubit>().updatePassword(value),
                          errorText: context.read<SignInCubit>().state.passwordError,
                        ),
                        const RememberForgotWidget(),
                        height10,
                        CustomGreenButtonWidget(
                          name: 'Login',
                          onPressed: isEmailLoading
                              ? null
                              : () {
                            final data = context.read<SignInCubit>().submitForm();
                            if (data != null) {
                              print('Dispatching AuthSignInWithEmailEvent: ${data['email']}');
                              context.read<SignInCubit>().setSubmitting(true);
                              context.read<AuthBloc>().add(
                                AuthSignInWithEmailEvent(
                                  email: data['email']!,
                                  password: data['password']!,
                                ),
                              );
                            }
                          },
                          child: isEmailLoading
                              ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                              : null,
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
                          isLoading: isGoogleLoading,
                          child: isGoogleLoading
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
            );
          },
        ),
      ),
    );
  }
}