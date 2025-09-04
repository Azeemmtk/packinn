import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String? id;
  final String userId;
  final String type; // "add", "deduct", "payment"
  final double amount;
  final String description;
  final DateTime timestamp;
  final String? paymentId;

  const TransactionEntity({
    this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    this.paymentId,
  });

  @override
  List<Object?> get props => [id, userId, type, amount, description, timestamp, paymentId];
}