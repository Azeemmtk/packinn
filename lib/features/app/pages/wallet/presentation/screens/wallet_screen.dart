import 'package:flutter/material.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/app/pages/wallet/presentation/widgets/wallet_card_widget.dart';

import '../../../../../../core/widgets/custom_app_bar_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(
            title: 'Wallet',
            enableChat: true,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return WalletCardWidget();
                },
                separatorBuilder: (context, index) => height20,
                itemCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
