import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/const.dart';
import '../provider/bloc/email/email_auth_bloc.dart';
import '../provider/bloc/email/email_auth_event.dart';
import '../provider/bloc/email/email_auth_state.dart';

class RememberForgotWidget extends StatefulWidget {
  const RememberForgotWidget({super.key});

  @override
  State<RememberForgotWidget> createState() => _RememberForgotWidgetState();
}

class _RememberForgotWidgetState extends State<RememberForgotWidget> {
  bool isCheck = false;

  void _showEmailInputDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enter Email Address'),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Enter your email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text.trim().toLowerCase();
              if (email.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                Navigator.pop(dialogContext);
                context.read<EmailAuthBloc>().add(EmailAuthSendPasswordReset(email: email));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid email address')),
                );
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailAuthBloc, EmailAuthState>(
      listener: (context, state) {
        if (state is EmailAuthPasswordResetSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset email sent! Check your inbox and follow the link to reset your password.'),
            ),
          );
        } else if (state is EmailAuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Row(
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
            onPressed: () => _showEmailInputDialog(context),
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
      ),
    );
  }
}