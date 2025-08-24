import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:packinn/core/services/stripe_services.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/features/app/pages/wallet/presentation/provider/bloc/payment_state.dart';

import '../../../domain/usecases/update_occupant_usecase.dart';

part 'payment_event.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final StripeService stripeService;
  final UpdateOccupantUseCase updateOccupantUseCase;

  PaymentBloc(this.stripeService, {UpdateOccupantUseCase? updateOccupantUseCase})
      : updateOccupantUseCase = updateOccupantUseCase ?? getIt<UpdateOccupantUseCase>(),
        super(PaymentInitial()) {
    on<MakePaymentEvent>(_onMakePayment);
  }

  Future<void> _onMakePayment(MakePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final success = await stripeService.makePayment(amount: event.amount);
      if (success) {
        final result = await updateOccupantUseCase(
          UpdateOccupantParams(
            occupantId: event.occupantId,
            hostelId: event.hostelId,
            roomId: event.roomId,
          ),
        );
        result.fold(
              (failure) => emit(PaymentError('Failed to update occupant: ${failure.message}')),
              (_) => emit(PaymentSuccess()),
        );
      } else {
        emit(PaymentError('Payment failed or canceled'));
      }
    } catch (e) {
      emit(PaymentError('Error occurred: $e'));
    }
  }
}