import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String? id;
  final String userId;
  final String occupantId;
  final String hostelId;
  final double amount;
  final double rent;
  final String? extraMessage;
  final double? extraAmount;
  final double? discount;
  final String occupantName;
  final String hostelName;
  final bool paymentStatus;
  final DateTime dueDate;

  const PaymentEntity({
    this.id,
    required this.userId,
    required this.occupantId,
    required this.hostelId,
    required this.amount,
    required this.rent,
    this.extraMessage,
    this.extraAmount,
    this.discount,
    required this.occupantName,
    required this.hostelName,
    required this.paymentStatus,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    occupantId,
    hostelId,
    amount,
    rent,
    extraMessage,
    extraAmount,
    discount,
    occupantName,
    paymentStatus,
    dueDate,
  ];
}