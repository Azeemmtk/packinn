import 'package:flutter/material.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(title: 'Profile'),
        ],
      ),
    );
  }
}
