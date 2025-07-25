import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';

class CustomAuthInputWidget extends StatefulWidget {
  const CustomAuthInputWidget(
      {super.key,
      this.isSecure = false,
      required this.title,
      required this.initial,
      required this.icon,
      });

  final bool isSecure;
  final String title;
  final String initial;
  final IconData icon;

  @override
  State<CustomAuthInputWidget> createState() => _CustomAuthWidgetState();
}

class _CustomAuthWidgetState extends State<CustomAuthInputWidget> {
  late bool secure = widget.isSecure ? true : false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: width * 0.043,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          obscureText: secure,
          decoration: InputDecoration(
            hintText: widget.initial,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
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
            prefixIcon: Container(
              margin: EdgeInsets.only(right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                      width: 15,
                    ),
                  ),
                ],
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
          ),
          style: TextStyle(color: Color(0xFF616161)),
        ),
      ],
    );
  }
}
