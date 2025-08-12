import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';

class IndividualChatScreen extends StatelessWidget {
  const IndividualChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(title: 'Azeem ali'),
        ],
      ),
    );
  }
}
