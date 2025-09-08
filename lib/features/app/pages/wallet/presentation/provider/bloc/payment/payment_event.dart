part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class MakePaymentEvent extends PaymentEvent {
  final double amount;
  final double amountToPay;
  final String? id;
  final String occupantId;
  final String roomType;
  final String hostelId;
  final String roomId;
  final bool isBooking;
  final double? roomRate;
  final String? extraMessage;
  final double? extraAmount;
  final double? discount;
  final String occupantImage;
  final String occupantName;
  final String hostelName;
  final DateTime? dueDate;
  final DateTime? registrationDate;
  final String paymentMethod; // New: "wallet" or "stripe"

  const MakePaymentEvent({
    required this.amount,
    required this.amountToPay,
    this.id,
    required this.occupantId,
    required this.roomType,
    required this.hostelId,
    required this.roomId,
    this.isBooking = false,
    this.roomRate,
    this.extraMessage,
    this.extraAmount,
    this.discount,
    this.dueDate,
    this.registrationDate,
    required this.occupantName,
    required this.occupantImage,
    required this.hostelName,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
    amount,
    amountToPay,
    id,
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
    paymentMethod,
    dueDate,
    registrationDate,
  ];
}

class SavePaymentEvent extends PaymentEvent {
  final PaymentModel paymentModel;

  const SavePaymentEvent(this.paymentModel);

  @override
  List<Object?> get props => [paymentModel];
}