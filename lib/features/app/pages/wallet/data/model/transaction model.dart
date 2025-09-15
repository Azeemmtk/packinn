import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String id;
  final String userId;
  final String type;
  final double amount;
  final String description;
  final DateTime? timestamp;
  final String? paymentId;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    this.timestamp,
    this.paymentId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    try {
      return TransactionModel(
        id: json['id'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        type: json['type'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        description: json['description'] as String? ?? '',
        timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
        paymentId: json['paymentId'] as String?,
      );
    } catch (e) {
      print('Error parsing TransactionModel: $e, JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'amount': amount,
      'description': description,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
      'paymentId': paymentId,
    };
  }

  @override
  List<Object?> get props => [id, userId, type, amount, description, timestamp, paymentId];
}