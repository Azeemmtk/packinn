part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletDataLoaded extends WalletState {
  final double balance; // Balance in INR
  final List<PaymentModel> payments;

  const WalletDataLoaded({
    this.balance = 0.0,
    this.payments = const [],
  });

  @override
  List<Object> get props => [balance, payments];
}

class TransactionsLoaded extends WalletState {
  final List<TransactionModel> transactions;

  const TransactionsLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object> get props => [message];
}