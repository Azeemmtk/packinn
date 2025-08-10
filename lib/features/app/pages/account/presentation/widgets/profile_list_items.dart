import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../auth/presentation/provider/bloc/auth_bloc.dart';

class ProfileListItems extends StatelessWidget {
  const ProfileListItems(
      {super.key, required this.text, required this.selectedIndex});

  final String text;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: padding),
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: text != 'Log out' ? headingTextColor : Colors.red),
            ),
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
