import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:packinn/core/services/stripe_services.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/update_occupant_usecase.dart';
import '../../../../data/model/payment_model.dart';
import '../../../../domain/repository/wallet_repository.dart';
import '../../../../domain/usecases/save_payment_use_case.dart';
import '../../../../domain/usecases/deduct_from_wallet_usecase.dart';
import 'payment_state.dart';

part 'payment_event.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final StripeService stripeService;
  final SavePaymentUseCase savePaymentUseCase;
  final UpdateOccupantUseCase updateOccupantUseCase;
  final DeductFromWalletUseCase deductFromWalletUseCase;
  final WalletRepository walletRepository;

  PaymentBloc(
      this.stripeService,
      this.savePaymentUseCase,
      this.updateOccupantUseCase,
      this.deductFromWalletUseCase,
      this.walletRepository,
      ) : super(PaymentInitial()) {
    on<MakePaymentEvent>(_onMakePayment);
    on<SavePaymentEvent>(_onSavePayment);
  }

  Future<void> _onMakePayment(MakePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      print('Starting payment process for occupantId: ${event.occupantId}, isBooking: ${event.isBooking}');

      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        print('User not authenticated');
        emit(const PaymentError('User not authenticated'));
        return;
      }
      print('Authenticated user ID: $userId');

      final rentAmount = event.isBooking ? (event.roomRate ?? 3000.0) : event.amount;
      bool paymentSuccess = false;
      String? paidVia = event.paymentMethod;

      if (event.paymentMethod == 'stripe') {
        final success = await stripeService.makePayment(amount: event.amountToPay); // amountToPay in INR
        if (!success) {
          print('Stripe payment failed or was canceled');
          emit(const PaymentError('Payment failed or canceled'));
          return;
        }
        paymentSuccess = true;
      } else if (event.paymentMethod == 'wallet') {
        final result = await deductFromWalletUseCase(DeductFromWalletParams(
          userId: userId,
          amount: event.amountToPay, // Amount in INR
          description: 'Payment for ${event.isBooking ? "booking" : "rent"} at ${event.hostelName}',
          paymentId: event.id,
        ));
        paymentSuccess = result.isRight();
        if (!paymentSuccess) {
          final failure = result.fold((f) => f, (_) => null);
          print('Wallet payment failed: ${failure?.message}');
          emit(PaymentError(failure?.message ?? 'Wallet payment failed'));
          return;
        }
      }

      if (paymentSuccess) {
        if (event.isBooking) {
          final now = DateTime.now();
          // Create booking payment record (registration fee)
          final paymentModel = PaymentModel(
            id: FirebaseFirestore.instance.collection('payments').doc().id,
            userId: userId,
            occupantId: event.occupantId,
            hostelId: event.hostelId,
            amount: 100.0, // Registration fee in INR
            rent: rentAmount,
            extraMessage: event.extraMessage,
            extraAmount: event.extraAmount,
            discount: event.discount,
            occupantName: event.occupantName,
            occupantImage: event.occupantImage,
            hostelName: event.hostelName,
            paymentStatus: true,
            dueDate: now,
            registrationDate: now,
            paidVia: paidVia,
          );

          print('Saving booking payment: ${paymentModel.toJson()}');
          final saveResult = await savePaymentUseCase(paymentModel);
          if (saveResult.isLeft()) {
            final failure = saveResult.fold((f) => f, (_) => null);
            print('Failed to save booking payment: ${failure?.message}');
            emit(PaymentError(failure?.message ?? 'Failed to save booking payment'));
            return;
          }

          print('Booking payment saved successfully');

          // Create rent payment record
          final rentPaymentModel = PaymentModel(
            id: FirebaseFirestore.instance.collection('payments').doc().id,
            userId: userId,
            occupantId: event.occupantId,
            hostelId: event.hostelId,
            amount: rentAmount,
            rent: rentAmount,
            extraMessage: event.extraMessage,
            extraAmount: event.extraAmount,
            discount: event.discount,
            occupantName: event.occupantName,
            occupantImage: event.occupantImage,
            hostelName: event.hostelName,
            paymentStatus: false,
            dueDate: now.add(const Duration(days: 5)),
            registrationDate: now,
            paidVia: null,
          );

          print('Saving rent payment: ${rentPaymentModel.toJson()}');
          final rentSaveResult = await savePaymentUseCase(rentPaymentModel);
          if (rentSaveResult.isLeft()) {
            final failure = rentSaveResult.fold((f) => f, (_) => null);
            print('Failed to save rent payment: ${failure?.message}');
            emit(PaymentError(failure?.message ?? 'Failed to save rent payment'));
            return;
          }

          print('Rent payment saved successfully');

          // Update occupant details
          final updateResult = await updateOccupantUseCase(UpdateOccupantParams(
            occupantId: event.occupantId,
            hostelId: event.hostelId,
            roomId: event.roomId,
            roomType: event.roomType,
          ));
          if (updateResult.isLeft()) {
            final failure = updateResult.fold((f) => f, (_) => null);
            print('Failed to update occupant: ${failure?.message}');
            emit(PaymentError(failure?.message ?? 'Failed to update occupant'));
            return;
          }

          print('Occupant updated successfully');
          emit(PaymentSuccess());
        } else {
          if (event.id == null) {
            print('No payment ID provided for non-booking payment');
            emit(const PaymentError('No payment ID provided'));
            return;
          }

          final updateResult = await walletRepository.updatePayment(event.id!, paidVia);
          if (updateResult.isLeft()) {
            final failure = updateResult.fold((f) => f, (_) => null);
            print('Failed to update payment: ${failure?.message}');
            emit(PaymentError(failure?.message ?? 'Failed to update payment'));
            return;
          }

          print('Payment updated successfully');
          emit(PaymentSuccess());
        }
      }
    } catch (e) {
      print('Unexpected error during payment: ${e.toString()}');
      emit(PaymentError('Payment failed: ${e.toString()}'));
    }
  }

  Future<void> _onSavePayment(SavePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    print('Saving payment via SavePaymentEvent: ${event.paymentModel.toJson()}');
    final result = await savePaymentUseCase(event.paymentModel);
    if (result.isLeft()) {
      final failure = result.fold((f) => f, (_) => null);
      print('Failed to save payment: ${failure?.message}');
      emit(PaymentError(failure?.message ?? 'Failed to save payment'));
    } else {
      print('Payment saved successfully via SavePaymentEvent');
      emit(PaymentSuccess());
    }
  }
}