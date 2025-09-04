part of 'wallet_bloc.dart';


abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List<PaymentModel> payments;

  const WalletLoaded(this.payments);

  @override
  List<Object> get props => [payments];
}

class WalletBalanceLoaded extends WalletState {
  final double balance;

  const WalletBalanceLoaded(this.balance);

  @override
  List<Object> get props => [balance];
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