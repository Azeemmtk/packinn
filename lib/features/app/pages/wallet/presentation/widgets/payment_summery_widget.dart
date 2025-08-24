import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/const.dart';
import '../../../../../../core/widgets/details_row_widget.dart';
import '../../../../../../core/widgets/title_text_widget.dart';

class PaymentSummeryWidget extends StatelessWidget {
  const PaymentSummeryWidget({
    super.key,
    this.isBooking = false,
  });
  final bool isBooking;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextWidget(title: 'Payment Summery'),
        height10,
        DetailsRowWidget(
            title: 'Room rent', value: isBooking ? '₹0000' : '₹4000'),
        height10,
        DetailsRowWidget(
            title: isBooking ? 'Booking charge' : 'Extra message',
            value: isBooking ? '₹100' : '₹300'),
        height10,
        DetailsRowWidget(
            title: 'Discount', value: isBooking ? '₹000' : '- ₹500'),
        height20,
        DottedLine(
          dashLength: 10,
        ),
        height20,
        DetailsRowWidget(
          title: 'Total price',
          value: '₹3900',
          isBold: true,
        ),
      ],
    );
  }
}
