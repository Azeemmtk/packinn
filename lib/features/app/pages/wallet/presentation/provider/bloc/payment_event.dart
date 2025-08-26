part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class MakePaymentEvent extends PaymentEvent {
  final double amount;
  final String occupantId;
  final String roomType;
  final String hostelId;
  final String roomId;
  final bool isBooking;
  final double? roomRate;
  final String? extraMessage;
  final double? extraAmount;
  final double? discount;
  final String occupantName;
  final String hostelName;

  const MakePaymentEvent({
    required this.amount,
    required this.occupantId,
    required this.roomType,
    required this.hostelId,
    required this.roomId,
    this.isBooking = false,
    this.roomRate,
    this.extraMessage,
    this.extraAmount,
    this.discount,
    required this.occupantName,
    required this.hostelName,
  });

  @override
  List<Object?> get props => [
    amount,
    occupantId,
    roomType,
    hostelId,
    roomId,
    isBooking,
    roomRate,
    extraMessage,
    extraAmount,
    discount,
    occupantName,
    hostelName,
  ];
}

class SavePaymentEvent extends PaymentEvent {
  final PaymentModel paymentModel;

  const SavePaymentEvent(this.paymentModel);

  @override
  List<Object?> get props => [paymentModel];
}