import 'package:flutter/material.dart';
import 'package:packinn/core/utils/date_formate.dart';
import '../../data/model/transaction model.dart';

class TransactionCardWidget extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCardWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 2,
      child: ListTile(
        title: Text(
          '${transaction.type.capitalize()} - ₹${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Text(
            '${transaction.description}\n${dateTimeFormate.format(transaction.timestamp!)}',
            style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

// Extension to capitalize string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
