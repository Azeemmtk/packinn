import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';

import '../constants/const.dart';

class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget({super.key, required this.text,this.isSecure=false});

  final String text;
  final bool isSecure;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late bool secure = widget.isSecure ? true : false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.9,
      height: height * 0.06,
      child: TextFormField(
        obscureText: secure,
        decoration: InputDecoration(
          hintText: widget.text,
          filled: true,
          suffixIcon: widget.isSecure
              ? IconButton(
            onPressed: () {
              setState(() {
                secure = !secure;
              });
            },
            icon: secure
                ? Icon(
              CupertinoIcons.eye_slash,
              size: width * 0.06,
              color: customGrey,
            )
                : Icon(
              CupertinoIcons.eye,
              size: width * 0.06,
              color: customGrey,
            ),
          )
              : null,
          fillColor: secondaryColor,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(width * 0.1,),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: mainColor),
            borderRadius: BorderRadius.circular(width * 0.1,),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(width * 0.1,),
          ),
        ),
      ),
    );
  }
}
