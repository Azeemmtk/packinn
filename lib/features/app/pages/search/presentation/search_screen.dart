import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_app_bar_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(title: 'Wallet',enableChat: true,),
        ],
      ),
    );
  }
}
