import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/const.dart';

class CustomAuthInputWidget extends StatefulWidget {
  const CustomAuthInputWidget({
    super.key,
    this.isSecure = false,
    required this.title,
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.errorText,
    this.isNum = false,
    this.controller,
  });

  final bool isNum;
  final bool isSecure;
  final String title;
  final String hint;
  final IconData icon;
  final Function(String) onChanged;
  final String? errorText;
  final TextEditingController? controller;

  @override
  State<CustomAuthInputWidget> createState() => _CustomAuthWidgetState();
}

class _CustomAuthWidgetState extends State<CustomAuthInputWidget> {
  late bool secure = widget.isSecure;
  late TextEditingController _controller;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _removeOverlay();
    super.dispose();
  }

  // void _showErrorOverlay(BuildContext context) {
  //   _removeOverlay();
  //
  //   final renderBox = context.findRenderObject() as RenderBox?;
  //   if (renderBox == null) return;
  //   final position = renderBox.localToGlobal(Offset.zero);
  //   final size = renderBox.size;
  //
  //   // Calculate screen size for boundary checking
  //   final screenSize = MediaQuery.of(context).size;
  //
  //   // Adjust position to ensure the overlay stays within screen bounds
  //   double left = position.dx;
  //   double top = position.dy + size.height + 8; // Below the field
  //   const overlayWidth = 200.0; // Fixed width for the overlay
  //   const overlayHeight = 40.0; // Approximate height
  //
  //   // Ensure the overlay doesn't go off-screen horizontally
  //   if (left + overlayWidth > screenSize.width) {
  //     left = screenSize.width - overlayWidth - 8; // Align to right edge with padding
  //   }
  //   if (left < 8) {
  //     left = 8; // Align to left edge with padding
  //   }
  //
  //   // Ensure the overlay doesn't go off-screen vertically
  //   if (top + overlayHeight > screenSize.height) {
  //     top = position.dy - overlayHeight - 8; // Place above the field
  //   }
  //
  //   _overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       left: left,
  //       top: top,
  //       width: overlayWidth,
  //       child: Material(
  //         elevation: 4,
  //         borderRadius: BorderRadius.circular(8),
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //           decoration: BoxDecoration(
  //             color: Colors.red[50],
  //             borderRadius: BorderRadius.circular(8),
  //             border: Border.all(color: Colors.red),
  //           ),
  //           child: Text(
  //             widget.errorText!,
  //             style: TextStyle(
  //               color: Colors.red,
  //               fontSize: width * 0.035,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   Overlay.of(context).insert(_overlayEntry!);
  //
  //   // Remove overlay after 2 seconds
  //   Future.delayed(const Duration(seconds: 2), () {
  //     _removeOverlay();
  //   });
  // }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

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
          controller: _controller,
          obscureText: secure,
          keyboardType: widget.isNum ? TextInputType.number : null,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            suffixIcon:
            // widget.errorText != null
            //     ? IconButton(
            //   onPressed: () {
            //     _showErrorOverlay(context);
            //   },
            //   icon: Icon(
            //     Icons.warning_amber_rounded,
            //     size: width * 0.06,
            //     color: Colors.red,
            //   ),
            // )
            //     : (
            widget.isSecure
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
                : null
            // )
            ,
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
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
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 2),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: mainColor, width: 2),
            ),
            errorText: widget.errorText, // Display error text directly below the field
            errorStyle: TextStyle(
              color: Colors.red,
              fontSize: width * 0.035,
            ),
          ),
          style: const TextStyle(color: Color(0xFF616161)),
        ),
      ],
    );
  }
}