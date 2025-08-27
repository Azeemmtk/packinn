import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/services/current_user.dart';
import 'package:packinn/features/app/pages/wallet/presentation/widgets/wallet_card_widget.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../provider/bloc/wallet/wallet_bloc.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WalletBloc>()..add(GetPayments(CurrentUser().uId!)),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBarWidget(
              title: 'Wallet',
              enableChat: true,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, state) {
                    if (state is WalletLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WalletLoaded) {
                      if (state.payments.isEmpty) {
                        return const Center(child: Text('No payments found'));
                      }
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return WalletCardWidget(payment: state.payments[index]);
                        },
                        separatorBuilder: (context, index) => height20,
                        itemCount: state.payments.length,
                      );
                    } else if (state is WalletError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: Text('Initialize Wallet'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}