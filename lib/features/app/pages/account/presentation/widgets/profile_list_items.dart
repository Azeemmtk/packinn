import 'package:flutter/material.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/features/app/pages/account/presentation/screens/profile_screen.dart';
import 'package:packinn/features/app/pages/account/presentation/screens/report_screen.dart';
import 'package:packinn/features/app/pages/account/presentation/widgets/terms_policy_dialog.dart';

import 'help_dialog.dart';

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
        } else if (text == 'Reports') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportScreen(),
            ),
          );
        } else if (text == 'Help') {
          showDialog(
            context: context,
            builder: (context) => const HelpDialog(),
          );
        } else if (text == 'About') {
          showDialog(
            context: context,
            builder: (context) => const AboutDialog(),
          );
        } else if (text == 'Terms & Policy') {
          showDialog(
            context: context,
            builder: (context) => const TermsPolicyDialog(),
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