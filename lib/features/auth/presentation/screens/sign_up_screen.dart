import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/otp/otp_auth_bloc.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/otp/otp_auth_event.dart';
import 'package:packinn/features/auth/presentation/provider/bloc/otp/otp_auth_state.dart';
import 'package:packinn/features/auth/presentation/screens/otp_screen.dart';
import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/features/auth/presentation/widgets/curved_container_widget.dart';
import 'package:packinn/features/auth/presentation/widgets/custom_auth_input_widget.dart';

import '../../../../core/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      _nameError = Validation.validateName(_nameController.text);
      _emailError = Validation.validateEmail(_emailController.text);
      _phoneError = Validation.validatePhone(_phoneController.text);
      _passwordError = Validation.validatePassword(_passwordController.text);
      _confirmPasswordError = Validation.validateConfirmPassword(
        _passwordController.text,
        _confirmPasswordController.text,
      );
      _isLoading = _nameError == null &&
          _emailError == null &&
          _phoneError == null &&
          _passwordError == null &&
          _confirmPasswordError == null;
    });

    if (_isLoading) {
      // First, check if email exists
      context.read<OtpAuthBloc>().add(OtpAuthCheckEmail(_emailController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OtpAuthBloc, OtpAuthState>(
        listener: (context, state) {
          if (state is OtpEmailChecked) {
            if (state.emailExists) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This account is already registered.'),
                ),
              );
            } else {
              // Email doesn't exist, proceed to send OTP
              context.read<OtpAuthBloc>().add(OtpAuthSendOtp('+91${_phoneController.text}'));
            }
          } else if (state is OtpSent) {
            print('=====================${state.verificationId}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                  data: {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'phone': _phoneController.text,
                    'password': _passwordController.text,
                  },
                  status: 'RE',
                  verificationId: state.verificationId,
                ),
              ),
            );
            setState(() {
              _isLoading = false;
            });
          } else if (state is OtpAuthError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              CurvedContainerWidget(height: height * 0.3, title: 'Sign up'),
              Padding(
                padding: EdgeInsets.all(width * 0.03),
                child: Column(
                  children: [
                    CustomAuthInputWidget(
                      title: 'Name',
                      hint: 'Enter name',
                      icon: CupertinoIcons.person,
                      controller: _nameController,
                      errorText: _nameError,
                      onChanged: (value) {
                        setState(() {
                          _nameError = Validation.validateName(value);
                        });
                      },
                    ),
                    height10,
                    CustomAuthInputWidget(
                      title: 'Mail',
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
                      title: 'Phone',
                      hint: '7994042391',
                      isNum: true,
                      icon: FontAwesomeIcons.mobileScreen,
                      controller: _phoneController,
                      errorText: _phoneError,
                      onChanged: (value) {
                        setState(() {
                          _phoneError = Validation.validatePhone(value);
                        });
                      },
                    ),
                    height10,
                    CustomAuthInputWidget(
                      title: 'Password',
                      hint: 'Enter password',
                      icon: CupertinoIcons.lock,
                      isSecure: true,
                      controller: _passwordController,
                      errorText: _passwordError,
                      onChanged: (value) {
                        setState(() {
                          _passwordError = Validation.validatePassword(value);
                          _confirmPasswordError = Validation.validateConfirmPassword(
                            value,
                            _confirmPasswordController.text,
                          );
                        });
                      },
                    ),
                    height10,
                    CustomAuthInputWidget(
                      title: 'Confirm password',
                      hint: 'Repeat password',
                      icon: CupertinoIcons.lock,
                      isSecure: true,
                      controller: _confirmPasswordController,
                      errorText: _confirmPasswordError,
                      onChanged: (value) {
                        setState(() {
                          _confirmPasswordError = Validation.validateConfirmPassword(
                            _passwordController.text,
                            value,
                          );
                        });
                      },
                    ),
                    SizedBox(height: height * 0.06),
                    CustomGreenButtonWidget(
                      name: 'Create account',
                      onPressed: _isLoading ? null : _validateAndSubmit,
                      isLoading: _isLoading,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account ? ',
                          style: TextStyle(fontSize: width * 0.042),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: width * 0.042,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ),
                        ),
                      ],
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