import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/const.dart';
import '../provider/bloc/otp/otp_auth_bloc.dart';
import '../provider/bloc/otp/otp_auth_event.dart';
import '../provider/bloc/otp/otp_auth_state.dart';
import '../screens/otp_screen.dart';

class RememberForgotWidget extends StatefulWidget {
  const RememberForgotWidget({super.key});

  @override
  State<RememberForgotWidget> createState() => _RememberForgotWidgetState();
}

class _RememberForgotWidgetState extends State<RememberForgotWidget> {
  bool isCheck = false;

  void _showPhoneInputDialog(BuildContext context) {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enter Phone Number'),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: 'Enter phone number'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final phone = phoneController.text.trim();
              if (phone.isNotEmpty && phone.length >= 10) {
                Navigator.pop(dialogContext);
                context.read<OtpAuthBloc>().add(OtpAuthSendOtp('+91$phone'));
                context.read<OtpAuthBloc>().stream.firstWhere((state) => state is OtpSent).then((state) {
                  if (state is OtpSent) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(
                          status: 'FP',
                          data: {},
                          verificationId: state.verificationId,
                        ),
                      ),
                    );
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid phone number')),
                );
              }
            },
            child: const Text('Send OTP'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: mainColor,
          value: isCheck,
          onChanged: (value) {
            setState(() {
              isCheck = !isCheck;
            });
          },
        ),
        Text(
          'Remember Me',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: width * 0.039,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => _showPhoneInputDialog(context),
          child: Text(
            'Forgot password?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: width * 0.041,
              color: mainColor,
            ),
          ),
        ),
      ],
    );
  }
}