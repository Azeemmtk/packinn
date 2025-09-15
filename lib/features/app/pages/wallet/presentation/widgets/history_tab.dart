import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/features/app/pages/wallet/presentation/widgets/transaction_card_widget.dart';

import '../../../../../../core/constants/const.dart';
import '../provider/bloc/wallet/wallet_bloc.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        print('History Tab State: $state');
        if (state is WalletLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WalletDataLoaded) {
          print('Transactions in HistoryTab: ${state.transactions}');
          if (state.transactions.isEmpty) {
            return const Center(child: Text('No transaction history'));
          }
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return TransactionCardWidget(transaction: state.transactions[index]);
            },
            separatorBuilder: (context, index) => height10,
            itemCount: state.transactions.length,
          );
        } else if (state is WalletError && state.message.contains('transactions')) {
          return Center(child: Text('Error loading transactions: ${state.message}'));
        }
        return const Center(child: Text('Loading Transactions...'));
      },
    );
  }
}