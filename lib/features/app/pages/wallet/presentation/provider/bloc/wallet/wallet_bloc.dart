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
    final currentBalance = state is WalletDataLoaded ? (state as WalletDataLoaded).balance : 0.0;
    await result.fold(
          (failure) async {
        emit(WalletError(failure.message));
      },
          (payments) async {
        print('Payments fetched: $payments');
        final balanceResult = await getWalletBalanceUseCase(event.userId);
        balanceResult.fold(
              (failure) => emit(WalletError(failure.message)),
              (balance) {
            print('Emitting WalletDataLoaded with balance: $balance, payments: $payments');
            emit(WalletDataLoaded(balance: balance, payments: payments));
          },
        );
      },
    );
  }

  Future<void> _onGetWalletBalance(GetWalletBalance event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    final result = await getWalletBalanceUseCase(event.userId);
    final currentPayments = state is WalletDataLoaded ? (state as WalletDataLoaded).payments : <PaymentModel>[];
    result.fold(
          (failure) => emit(WalletError(failure.message)),
          (balance) {
        print('Emitting WalletDataLoaded with balance: $balance');
        emit(WalletDataLoaded(balance: balance, payments: currentPayments));
      },
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
        amount: event.amount,
        description: event.description,
      ));
      if (result.isLeft()) {
        final failure = result.fold((f) => f, (_) => null);
        emit(WalletError(failure?.message ?? 'Failed to add to wallet'));
        return;
      }

      // Update balance in INR
      double currentBalance = state is WalletDataLoaded ? (state as WalletDataLoaded).balance : 0.0;
      final currentPayments = state is WalletDataLoaded ? (state as WalletDataLoaded).payments : <PaymentModel>[];
      emit(WalletDataLoaded(balance: currentBalance + event.amount, payments: currentPayments));
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