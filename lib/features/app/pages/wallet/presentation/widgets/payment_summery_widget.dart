import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/details_row_widget.dart';
import 'package:packinn/core/widgets/title_text_widget.dart';

class PaymentSummeryWidget extends StatelessWidget {
  const PaymentSummeryWidget({
    super.key,
    this.isBooking = false,
    this.extraMessage,
    this.extraAmount,
    this.discount,
    required this.rent,
  });

  ///

  final bool isBooking;
  final String? extraMessage;
  final double? extraAmount;
  final double? discount;
  final double rent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextWidget(title: 'Payment Summary'),
        SizedBox(height: height * 0.02),
        DetailsRowWidget(title: isBooking ? 'Registration fee' : 'Rent', value: isBooking ? '100' : rent.toString()),
        if (extraAmount != null) ...[
          SizedBox(height: height * 0.01),
          DetailsRowWidget(title: 'Extra amount', value: extraAmount.toString())
        ],
        if (discount != null) ...[
          SizedBox(height: height * 0.01),
          DetailsRowWidget(title: 'Discount', value: '-\$${discount!.toStringAsFixed(2)}')
        ],
        if (extraMessage != null) ...[
          SizedBox(height: height * 0.01),
          Text(
            'Note: $extraMessage',
            style: TextStyle(color: headingTextColor, fontStyle: FontStyle.italic),
          ),
        ],
        SizedBox(height: height * 0.02),
        DottedLine(
          dashLength: 6,
        ),
        SizedBox(height: height * 0.02),
        DetailsRowWidget(title: 'Total', value: '\$${(isBooking ? 100 : rent + (extraAmount ?? 0) - (discount ?? 0)).toStringAsFixed(2)}')
      ],
    );
  }
}