part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class MakePaymentEvent extends PaymentEvent {
  final double amount;
  final String occupantId;
  final String hostelId;
  final String roomId;

  const MakePaymentEvent({
    required this.amount,
    required this.occupantId,
    required this.hostelId,
    required this.roomId,
  });

  @override
  List<Object> get props => [amount, occupantId, hostelId, roomId];
}