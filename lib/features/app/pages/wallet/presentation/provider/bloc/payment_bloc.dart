import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:packinn/core/services/stripe_services.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/update_occupant_usecase.dart';
import 'package:packinn/features/app/pages/wallet/presentation/provider/bloc/payment_state.dart';

import '../../../data/model/payment_model.dart';
import '../../../domain/usecases/save_payment_use_case.dart';

part 'payment_event.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final StripeService stripeService;
  final SavePaymentUseCase savePaymentUseCase;
  final UpdateOccupantUseCase updateOccupantUseCase;

  PaymentBloc(
      this.stripeService,
      this.savePaymentUseCase,
      this.updateOccupantUseCase,
      ) : super(PaymentInitial()) {
    on<MakePaymentEvent>(_onMakePayment);
    on<SavePaymentEvent>(_onSavePayment);
  }

  Future<void> _onMakePayment(MakePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      print('Starting payment process for occupantId: ${event.occupantId}, isBooking: ${event.isBooking}');

      // Process payment via Stripe
      final success = await stripeService.makePayment(amount: event.amount);
      if (!success) {
        print('Stripe payment failed or was canceled');
        emit(const PaymentError('Payment failed or canceled'));
        return;
      }
      print('Stripe payment successful');

      // Get current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        print('User not authenticated');
        emit(const PaymentError('User not authenticated'));
        return;
      }
      print('Authenticated user ID: $userId');

      // Handle payment logic
      final now = DateTime.now();
      final oneMonthLater = DateTime(now.year, now.month + 1, now.day);
      final rentAmount = event.isBooking ? (event.roomRate ?? 3000.0) : event.amount;

      // Create payment record for the current payment
      final paymentModel = PaymentModel(
        id: FirebaseFirestore.instance.collection('payments').doc().id,
        userId: userId,
        occupantId: event.occupantId,
        hostelId: event.hostelId,
        amount: event.isBooking ? 100.0 : event.amount,
        rent: rentAmount,
        extraMessage: event.extraMessage,
        extraAmount: event.extraAmount,
        discount: event.discount,
        occupantName: event.occupantName,
        hostelName: event.hostelName,
        paymentStatus: true,
        dueDate: now,
      );

      print('Saving payment: ${paymentModel.toJson()}');

      // Save the current payment
      final saveResult = await savePaymentUseCase(paymentModel);
      await saveResult.fold(
            (failure) async {
          print('Failed to save current payment: ${failure.message}');
          emit(PaymentError(failure.message));
        },
            (_) async {
          print('Current payment saved successfully');

          // If it's a booking, create a second payment record for the rent
          if (event.isBooking) {
            final rentPaymentModel = PaymentModel(
              id: FirebaseFirestore.instance.collection('payments').doc().id,
              userId: userId,
              occupantId: event.occupantId,
              hostelId: event.hostelId,
              amount: rentAmount, // Rent amount for future payment
              rent: rentAmount,
              extraMessage: event.extraMessage,
              extraAmount: event.extraAmount,
              discount: event.discount,
              occupantName: event.occupantName,
              hostelName: event.hostelName,
              paymentStatus: false, // Rent payment is pending
              dueDate: oneMonthLater,
            );

            print('Saving rent payment: ${rentPaymentModel.toJson()}');

            final rentSaveResult = await savePaymentUseCase(rentPaymentModel);
            rentSaveResult.fold(
                  (failure) {
                print('Failed to save rent payment: ${failure.message}');
                emit(PaymentError(failure.message));
              },
                  (_) => print('Rent payment saved successfully'),
            );
          }

          // Update occupant details
          print('Updating occupant with params: occupantId=${event.occupantId}, hostelId=${event.hostelId}, roomId=${event.roomId}, roomType=${event.roomType}');
          final updateResult = await updateOccupantUseCase(UpdateOccupantParams(
            occupantId: event.occupantId,
            roomId: event.roomId,
            roomType: event.roomType,
            hostelId: event.hostelId,
          ));
          updateResult.fold(
                (failure) {
              print('Failed to update occupant: ${failure.message}');
              emit(PaymentError(failure.message));
            },
                (_) {
              print('Occupant updated successfully');
              emit(PaymentSuccess());
            },
          );
        },
      );
    } catch (e) {
      print('Unexpected error during payment: ${e.toString()}');
      emit(PaymentError('Payment failed: ${e.toString()}'));
    }
  }

  Future<void> _onSavePayment(SavePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    print('Saving payment via SavePaymentEvent: ${event.paymentModel.toJson()}');
    final result = await savePaymentUseCase(event.paymentModel);
    result.fold(
          (failure) {
        print('Failed to save payment: ${failure.message}');
        emit(PaymentError(failure.message));
      },
          (_) {
        print('Payment saved successfully via SavePaymentEvent');
        emit(PaymentSuccess());
      },
    );
  }
}