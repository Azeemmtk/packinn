import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_app_bar_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

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
