import 'package:flutter/material.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/features/app/pages/account/presentation/screens/profile_screen.dart';

class ProfileListItems extends StatelessWidget {
  const ProfileListItems({
    super.key,
    required this.text,
    required this.selectedIndex,
  });

  final String text;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (text == 'Profile') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(),
            ),
          );
        }
      },
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
                color: text != 'Log out' ? headingTextColor : Colors.red,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}