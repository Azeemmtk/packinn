import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/payment_entity.dart';

class PaymentModel {
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

  PaymentModel({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'occupantId': occupantId,
      'hostelId': hostelId,
      'amount': amount,
      'rent': rent,
      'extraMessage': extraMessage,
      'extraAmount': extraAmount,
      'discount': discount,
      'occupantName': occupantName,
      'paymentStatus': paymentStatus,
      'dueDate': Timestamp.fromDate(dueDate),
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      userId: json['userId'],
      occupantId: json['occupantId'],
      hostelId: json['hostelId'],
      amount: (json['amount'] as num).toDouble(),
      rent: (json['rent'] as num).toDouble(),
      extraMessage: json['extraMessage'],
      extraAmount: json['extraAmount'] != null ? (json['extraAmount'] as num).toDouble() : null,
      discount: json['discount'] != null ? (json['discount'] as num).toDouble() : null,
      occupantName: json['occupantName'],
      hostelName: json['hostelName'],
      paymentStatus: json['paymentStatus'] ?? false,
      dueDate: (json['dueDate'] as Timestamp).toDate(),
    );
  }

  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      userId: userId,
      occupantId: occupantId,
      hostelId: hostelId,
      amount: amount,
      rent: rent,
      extraMessage: extraMessage,
      extraAmount: extraAmount,
      discount: discount,
      occupantName: occupantName,
      hostelName :hostelName,
      paymentStatus: paymentStatus,
      dueDate: dueDate,
    );
  }

  factory PaymentModel.fromEntity(PaymentEntity entity) {
    return PaymentModel(
      id: entity.id,
      userId: entity.userId,
      occupantId: entity.occupantId,
      hostelId: entity.hostelId,
      amount: entity.amount,
      rent: entity.rent,
      extraMessage: entity.extraMessage,
      extraAmount: entity.extraAmount,
      discount: entity.discount,
      occupantName: entity.occupantName,
      hostelName: entity.hostelName,
      paymentStatus: entity.paymentStatus,
      dueDate: entity.dueDate,
    );
  }
}