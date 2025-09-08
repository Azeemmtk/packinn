import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/services/current_user.dart';
import 'package:packinn/features/app/pages/wallet/presentation/widgets/wallet_card_widget.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../provider/bloc/wallet/wallet_bloc.dart';
import 'add_money_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WalletBloc>()
        ..add(GetPayments(CurrentUser().uId!))
        ..add(GetWalletBalance(userId: CurrentUser().uId!)),
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
                          print('-----------------------${state.balance}');
                          balance = state.balance;
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Balance: ₹${balance.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
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
                      // Pending Tab
                      BlocBuilder<WalletBloc, WalletState>(
                        builder: (context, state) {
                          print('Pending Tab State: $state');
                          if (state is WalletLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is WalletDataLoaded) {
                            print('Pending Payments: ${state.payments}');
                            final pendingPayments = state.payments.where((p) => !p.paymentStatus).toList();
                            if (pendingPayments.isEmpty) {
                              return const Center(child: Text('No pending payments'));
                            }
                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return WalletCardWidget(payment: pendingPayments[index]);
                              },
                              separatorBuilder: (context, index) => height20,
                              itemCount: pendingPayments.length,
                            );
                          } else if (state is WalletError) {
                            return Center(child: Text(state.message));
                          }
                          return const Center(child: Text('Initialize Wallet'));
                        },
                      ),
                      // History Tab
                      BlocBuilder<WalletBloc, WalletState>(
                        builder: (context, state) {
                          print('History Tab State: $state');
                          if (state is WalletLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is WalletDataLoaded) {
                            print('Paid Payments: ${state.payments}');
                            final paidPayments = state.payments.where((p) => p.paymentStatus).toList();
                            if (paidPayments.isEmpty) {
                              return const Center(child: Text('No payment history'));
                            }
                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return WalletCardWidget(payment: paidPayments[index]);
                              },
                              separatorBuilder: (context, index) => height20,
                              itemCount: paidPayments.length,
                            );
                          } else if (state is WalletError) {
                            return Center(child: Text(state.message));
                          }
                          return const Center(child: Text('Initialize Wallet'));
                        },
                      ),
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