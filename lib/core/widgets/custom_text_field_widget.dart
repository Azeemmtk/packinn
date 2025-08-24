import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/const.dart';

class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.hintText,
    required this.fieldName,
    this.isSecure = false,
    this.errorText,
    this.onChanged,
    this.expanded = false,
    required this.controller,
     this.validator,
    this.keyboardType,
  });

  final String hintText;
  final String fieldName;
  final bool isSecure;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool expanded;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late bool secure = widget.isSecure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.fieldName, style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),),
        height5,
        TextFormField(
          controller: widget.controller,
          obscureText: secure,
          minLines: widget.expanded ? 4 : 1,
          maxLines: widget.expanded ? 4 : 1,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hintText,
            errorText: widget.errorText,
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
            fillColor: textFieldColor,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(width * 0.05),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainColor),
              borderRadius: BorderRadius.circular(width * 0.05),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(width * 0.05),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(width * 0.05),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(width * 0.05),
            ),
          ),
        ),
      ],
    );
  }
}