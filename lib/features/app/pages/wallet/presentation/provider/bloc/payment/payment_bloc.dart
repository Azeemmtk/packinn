import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:packinn/core/services/stripe_services.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/update_occupant_usecase.dart';
import 'package:packinn/features/app/pages/wallet/presentation/provider/bloc/payment/payment_state.dart';

import '../../../../data/model/payment_model.dart';
import '../../../../domain/usecases/save_payment_use_case.dart';

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

  Future<void> _onMakePayment(
      MakePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      print(
          'Starting payment process for occupantId: ${event.occupantId}, isBooking: ${event.isBooking}');

      // Process payment via Stripe
      final success = await stripeService.makePayment(amount: event.amountToPay);
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
      // final oneMonthLater = DateTime(now.year, now.month + 1, now.day);
      final rentAmount =
          event.isBooking ? (event.roomRate ?? 3000.0) : event.amount;

      if(event.isBooking){
        // Create payment record for the booking payment
        final paymentModel = PaymentModel(
          id: FirebaseFirestore.instance.collection('payments').doc().id,
          userId: userId,
          occupantId: event.occupantId,
          hostelId: event.hostelId,
          isBooking: true,
          amount: 100.0,
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
        );

        print('Saving booking payment: ${paymentModel.toJson()}');

        // Save the booking payment
        final saveResult = await savePaymentUseCase(paymentModel);
        await saveResult.fold(
              (failure) async {
            print('Failed to save booking payment: ${failure.message}');
            emit(PaymentError(failure.message));
          },
              (_) async {
            print('Booking payment saved successfully');

            // Create a second payment record for the rent
            final rentPaymentModel = PaymentModel(
              id: FirebaseFirestore.instance.collection('payments').doc().id,
              userId: userId,
              occupantId: event.occupantId,
              isBooking: false,
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
              dueDate: now.add(Duration(days: 5)),
              registrationDate: now,
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

            // Update occupant details
            print(
                'Updating occupant with params: occupantId=${event.occupantId}, hostelId=${event.hostelId}, roomId=${event.roomId}, roomType=${event.roomType}');
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
      } else {
        // For non-booking payment, update the existing payment record
        if (event.id == null) {
          print('No payment ID provided for non-booking payment');
          emit(const PaymentError('No payment ID provided'));
          return;
        }

        final paymentModel = PaymentModel(
          id: event.id,
          userId: userId,
          occupantId: event.occupantId,
          hostelId: event.hostelId,
          isBooking: false,
          amount: event.amount,
          rent: rentAmount,
          extraMessage: event.extraMessage,
          extraAmount: event.extraAmount,
          discount: event.discount,
          occupantName: event.occupantName,
          occupantImage: event.occupantImage,
          hostelName: event.hostelName,
          paymentStatus: true,
          dueDate: event.dueDate!,
          registrationDate: event.registrationDate!,
        );

        print('Updating payment: ${paymentModel.toJson()}');

        // Save (update) the payment
        final saveResult = await savePaymentUseCase(paymentModel);
        saveResult.fold(
              (failure) {
            print('Failed to update payment: ${failure.message}');
            emit(PaymentError(failure.message));
          },
              (_) {
            print('Payment updated successfully');
            emit(PaymentSuccess());
          },
        );
      }
    } catch (e) {
      print('Unexpected error during payment: ${e.toString()}');
      emit(PaymentError('Payment failed: ${e.toString()}'));
    }
  }

  Future<void> _onSavePayment(
      SavePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    print(
        'Saving payment via SavePaymentEvent: ${event.paymentModel.toJson()}');
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
