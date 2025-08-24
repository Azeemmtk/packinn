import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:pinput/pinput.dart';

import '../provider/cubit/otp_cubit.dart';

class OtpInputField extends StatelessWidget {
  const OtpInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: mainColor),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Pinput(
        length: 6,
        autofocus: true,
        defaultPinTheme: defaultPinTheme,
        onChanged: (value) {
          context.read<OtpCubit>().updateOtp(value);
        },
        keyboardType: TextInputType.number,
        showCursor: true,
      ),
    );
  }
}
