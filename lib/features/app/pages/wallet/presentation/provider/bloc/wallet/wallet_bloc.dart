import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:packinn/features/app/pages/wallet/data/model/payment_model.dart';
import '../../../../domain/usecases/get_payment_usecase.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetPaymentsUseCase getPaymentsUseCase;

  WalletBloc(this.getPaymentsUseCase) : super(WalletInitial()) {
    on<GetPayments>(_onFetchPayments);
  }

  Future<void> _onFetchPayments(
    GetPayments event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    print('bloc======${event.userId}');
    final result = await getPaymentsUseCase(event.userId);
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (payments) => emit(WalletLoaded(payments)),
    );
  }
}
