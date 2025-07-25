import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';

import '../../../../core/constants/const.dart';

class OTPInputWidget extends StatelessWidget {
  const OTPInputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _OtpField(),
        width10,
        _OtpField(),
        width10,
        _OtpField(),
        width10,
        _OtpField(),
      ],
    );
  }
}

class _OtpField extends StatelessWidget {
  const _OtpField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: 50,
        child: TextFormField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainColor,width: 2,),
            ),
          ),
        )
    );
  }
}
