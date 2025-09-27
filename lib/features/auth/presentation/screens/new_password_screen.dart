// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:packinn/core/constants/const.dart';
// import 'package:packinn/core/utils/validators.dart';
// import 'package:packinn/core/widgets/custom_green_button_widget.dart';
// import 'package:packinn/core/widgets/custom_text_field_widget.dart';
// import 'package:packinn/features/auth/presentation/provider/bloc/email/email_auth_bloc.dart';
// import 'package:packinn/features/auth/presentation/provider/bloc/email/email_auth_event.dart';
// import 'package:packinn/features/auth/presentation/provider/bloc/email/email_auth_state.dart';
// import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';
//
// class NewPasswordScreen extends StatefulWidget {
//   final String uid;
//
//   const NewPasswordScreen({super.key, required this.uid});
//
//   @override
//   State<NewPasswordScreen> createState() => _NewPasswordScreenState();
// }
//
// class _NewPasswordScreenState extends State<NewPasswordScreen> {
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   String? _newPasswordError;
//   String? _confirmPasswordError;
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   void _validateAndSubmit() {
//     setState(() {
//       _newPasswordError = Validation.validatePassword(_newPasswordController.text);
//       _confirmPasswordError = Validation.validateConfirmPassword(
//         _newPasswordController.text,
//         _confirmPasswordController.text,
//       );
//       _isLoading = _newPasswordError == null && _confirmPasswordError == null;
//     });
//
//     if (_isLoading) {
//       context.read<EmailAuthBloc>().add(
//         EmailAuthUpdatePassword(
//           uid: widget.uid,
//           newPassword: _newPasswordController.text,
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: BlocListener<EmailAuthBloc, EmailAuthState>(
//         listener: (context, state) {
//           if (state is EmailAuthPasswordUpdated) {
//             setState(() {
//               _isLoading = false;
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Password updated successfully!')),
//             );
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => const SignInScreen()),
//                   (route) => false,
//             );
//           } else if (state is EmailAuthError) {
//             setState(() {
//               _isLoading = false;
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//             if (state.message.contains('Please sign in again')) {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => const SignInScreen()),
//                     (route) => false,
//               );
//             }
//           }
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: MediaQuery.of(context).size.height -
//                     MediaQuery.of(context).padding.top -
//                     MediaQuery.of(context).padding.bottom,
//               ),
//               child: IntrinsicHeight(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(height: height * 0.3),
//                     Text(
//                       'Setup new password',
//                       style: TextStyle(
//                         fontSize: width * 0.06,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(height: height * 0.01),
//                     Text(
//                       'Please, setup a new password for your account',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: width * 0.05),
//                     ),
//                     SizedBox(height: height * 0.02),
//                     CustomTextFieldWidget(
//                       fieldName: 'New Password',
//                       hintText: 'New Password',
//                       isSecure: true,
//                       controller: _newPasswordController,
//                       errorText: _newPasswordError,
//                       onChanged: (value) {
//                         setState(() {
//                           _newPasswordError = Validation.validatePassword(value);
//                           _confirmPasswordError = Validation.validateConfirmPassword(
//                             value,
//                             _confirmPasswordController.text,
//                           );
//                         });
//                       },
//                     ),
//                     SizedBox(height: height * 0.01),
//                     CustomTextFieldWidget(
//                       fieldName: 'Repeat Password',
//                       hintText: 'Repeat Password',
//                       isSecure: true,
//                       controller: _confirmPasswordController,
//                       errorText: _confirmPasswordError,
//                       onChanged: (value) {
//                         setState(() {
//                           _confirmPasswordError = Validation.validateConfirmPassword(
//                             _newPasswordController.text,
//                             value,
//                           );
//                         });
//                       },
//                     ),
//                     const Spacer(),
//                     CustomGreenButtonWidget(
//                       name: 'Update Password',
//                       onPressed: _isLoading ? null : _validateAndSubmit,
//                       isLoading: _isLoading,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => const SignInScreen()),
//                               (route) => false,
//                         );
//                       },
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(fontSize: width * 0.045),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }