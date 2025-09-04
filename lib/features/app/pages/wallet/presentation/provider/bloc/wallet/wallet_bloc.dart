import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:packinn/core/services/stripe_services.dart';
import 'package:packinn/features/app/pages/wallet/data/model/payment_model.dart';
import '../../../../data/model/transaction model.dart';
import '../../../../domain/usecases/get_payment_usecase.dart';
import '../../../../domain/usecases/get_transaction_usecase.dart';
import '../../../../domain/usecases/get_wallet_balance_usecase.dart';
import '../../../../domain/usecases/add_to_wallet_usecase.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetPaymentsUseCase getPaymentsUseCase;
  final GetWalletBalanceUseCase getWalletBalanceUseCase;
  final AddToWalletUseCase addToWalletUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final StripeService stripeService;

  WalletBloc(
      this.getPaymentsUseCase,
      this.getWalletBalanceUseCase,
      this.addToWalletUseCase,
      this.getTransactionsUseCase,
      this.stripeService,
      ) : super(WalletInitial()) {
    on<GetPayments>(_onFetchPayments);
    on<GetWalletBalance>(_onGetWalletBalance);
    on<AddToWallet>(_onAddToWallet);
    on<GetTransactions>(_onGetTransactions);
  }

  Future<void> _onFetchPayments(GetPayments event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    print('bloc======${event.userId}');
    final result = await getPaymentsUseCase(event.userId);
    result.fold(
          (failure) => emit(WalletError(failure.message)),
          (payments) => emit(WalletLoaded(payments)),
    );
  }

  Future<void> _onGetWalletBalance(GetWalletBalance event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await getWalletBalanceUseCase(event.userId);
    result.fold(
          (failure) => emit(WalletError(failure.message)),
          (balance) => emit(WalletBalanceLoaded(balance)), // Balance in INR
    );
  }

  Future<void> _onAddToWallet(AddToWallet event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      final success = await stripeService.makePayment(amount: event.amount); // Amount in INR
      if (!success) {
        emit(const WalletError('Payment failed or canceled'));
        return;
      }
      final result = await addToWalletUseCase(AddToWalletParams(
        userId: event.userId,
        amount: event.amount, // Amount in INR
        description: event.description,
      ));
      if (result.isLeft()) {
        final failure = result.fold((f) => f, (_) => null);
        emit(WalletError(failure?.message ?? 'Failed to add to wallet'));
        return;
      }

      // Update balance in INR
      double currentBalance = state is WalletBalanceLoaded ? (state as WalletBalanceLoaded).balance : 0.0;
      emit(WalletBalanceLoaded(currentBalance + event.amount));
    } catch (e) {
      emit(WalletError('Failed to add money: $e'));
    }
  }

  Future<void> _onGetTransactions(GetTransactions event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await getTransactionsUseCase(event.userId);
    result.fold(
          (failure) => emit(WalletError(failure.message)),
          (transactions) => emit(TransactionsLoaded(transactions)),
    );
  }
}