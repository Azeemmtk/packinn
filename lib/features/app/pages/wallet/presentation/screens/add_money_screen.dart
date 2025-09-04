import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/services/current_user.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import '../provider/bloc/wallet/wallet_bloc.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WalletBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Money to Wallet')),
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (INR)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: height * 0.02),
              BlocConsumer<WalletBloc, WalletState>(
                listener: (context, state) {
                  if (state is WalletError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is WalletLoaded) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return CustomGreenButtonWidget(
                    name: state is WalletLoading ? 'Processing...' : 'Add via Stripe',
                    onPressed: state is WalletLoading
                        ? null
                        : () {
                      final amount = double.tryParse(_amountController.text);
                      if (amount != null && amount > 0) {
                        context.read<WalletBloc>().add(AddToWallet(
                          amount: amount, // Amount in INR
                          description: 'Added via Stripe',
                          userId: CurrentUser().uId!,
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid amount in INR')),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}