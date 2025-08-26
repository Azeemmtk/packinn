import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/title_text_widget.dart';

class PaymentSummeryWidget extends StatelessWidget {
  const PaymentSummeryWidget({
    super.key,
    this.isBooking = false,
    this.extraMessage,
    this.extraAmount,
    this.discount,
  });

  final bool isBooking;
  final String? extraMessage;
  final double? extraAmount;
  final double? discount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextWidget(title: 'Payment Summary'),
        SizedBox(height: height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Amount', style: TextStyle(color: headingTextColor)),
            Text('\$${isBooking ? 100 : 3000}', style: TextStyle(color: headingTextColor)),
          ],
        ),
        if (extraAmount != null) ...[
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Extra Amount', style: TextStyle(color: headingTextColor)),
              Text('\$${extraAmount!.toStringAsFixed(2)}', style: TextStyle(color: headingTextColor)),
            ],
          ),
        ],
        if (discount != null) ...[
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discount', style: TextStyle(color: headingTextColor)),
              Text('-\$${discount!.toStringAsFixed(2)}', style: TextStyle(color: headingTextColor)),
            ],
          ),
        ],
        if (extraMessage != null) ...[
          SizedBox(height: height * 0.01),
          Text(
            'Note: $extraMessage',
            style: TextStyle(color: headingTextColor, fontStyle: FontStyle.italic),
          ),
        ],
        SizedBox(height: height * 0.02),
        Divider(color: headingTextColor),
        SizedBox(height: height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: TextStyle(fontWeight: FontWeight.bold, color: headingTextColor)),
            Text(
              '\$${(isBooking ? 100 : 3000 + (extraAmount ?? 0) - (discount ?? 0)).toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold, color: headingTextColor),
            ),
          ],
        ),
      ],
    );
  }
}