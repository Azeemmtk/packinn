part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class GetPayments extends WalletEvent {
  final String userId;

  const GetPayments(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetWalletBalance extends WalletEvent {
  final String userId;

  const GetWalletBalance({this.userId = ''});

  @override
  List<Object?> get props => [userId];
}

class AddToWallet extends WalletEvent {
  final double amount;
  final String description;
  final String userId;

  const AddToWallet({required this.amount, required this.description, required this.userId});

  @override
  List<Object?> get props => [amount, description, userId];
}

class GetTransactions extends WalletEvent {
  final String userId;

  const GetTransactions(this.userId);

  @override
  List<Object?> get props => [userId];
}

class InitializeWallet extends WalletEvent {
  final String userId;

  const InitializeWallet(this.userId);

  @override
  List<Object?> get props => [userId];
}