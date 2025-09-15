import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/services/current_user.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../provider/bloc/wallet/wallet_bloc.dart';
import '../widgets/history_tab.dart';
import '../widgets/pendig_tab.dart';
import 'add_money_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Current User ID: ${CurrentUser().uId}');
    return BlocProvider(
      create: (context) => getIt<WalletBloc>()
        ..add(InitializeWallet(CurrentUser().uId!)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              CustomAppBarWidget(
                title: 'Wallet',
                enableChat: true,
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, state) {
                        double balance = 0.0;
                        if (state is WalletDataLoaded) {
                          print('Balance: ${state.balance}');
                          balance = state.balance;
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Balance: ₹${balance.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddMoneyScreen()),
                                );
                              },
                              child: const Text('Add Money'),
                            ),
                          ],
                        );
                      },
                    ),
                    const TabBar(
                      tabs: [
                        Tab(text: 'Pending'),
                        Tab(text: 'History'),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: TabBarView(
                    children: [
                      PendingTab(),
                      HistoryTab(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}