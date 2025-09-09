import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/features/app/pages/wallet/presentation/widgets/wallet_card_widget.dart';

import '../../../../../../core/constants/const.dart';
import '../provider/bloc/wallet/wallet_bloc.dart';

class PendingTab extends StatelessWidget {
  const PendingTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
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
        } else if (state is WalletError && state.message.contains('payments')) {
          return Center(child: Text('Error loading payments: ${state.message}'));
        }
        return const Center(child: Text('Loading Payments...'));
      },
    );
  }
}