import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/app/pages/wallet/data/model/payment_model.dart';
import 'package:packinn/features/app/pages/wallet/presentation/screens/payment_screen.dart';

class WalletCardWidget extends StatelessWidget {
  final PaymentModel payment;

  const WalletCardWidget({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final isOverdue = !payment.paymentStatus && payment.dueDate.isBefore(DateTime.now());
    return InkWell(
      onTap: () {
        print(' wallet screen${payment.id}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              status: payment.paymentStatus,
              id: payment.id,
              occupantId: payment.occupantId,
              occupantName: payment.occupantName,
              occupantImage: payment.occupantImage,
              extraMessage: payment.extraMessage,
              extraAmount: payment.extraAmount,
              discount: payment.discount,
              dueDate: payment.dueDate,
              registrationDate: payment.registrationDate,
              room: {
                'hostelId': payment.hostelId,
                'hostelName': payment.hostelName,
                'roomId': payment.id,
                'rate': payment.rent,
              },
              isBooking: false,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          // border: isOverdue ? Border.all(color: Colors.red, width: 2) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                payment.occupantImage,
                width: width * 0.35,
                height: height * 0.14,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  imagePlaceHolder,
                  width: width * 0.35,
                  height: height * 0.14,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.hostelName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    payment.occupantName,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'RENT - ${payment.amount + (payment.extraAmount ?? 0) - (payment.discount ?? 0)}',
                        style: const TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' - ${payment.paymentStatus ? 'Paid' : 'Due'}',
                        style: TextStyle(
                          color: payment.paymentStatus ? mainColor : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Due: ${DateFormat('dd-MMM-yyyy').format(payment.dueDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverdue ? Colors.red : Colors.grey,
                    ),
                  ),

                  if (payment.paidVia != null)
                    Text(
                      'Paid via: ${payment.paidVia}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}