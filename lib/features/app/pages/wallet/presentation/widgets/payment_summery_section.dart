import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/features/app/pages/wallet/presentation/widgets/payment_summery_widget.dart';
import '../../../../main_screen/presentation/screen/main_screen.dart';
import '../../../home/presentation/provider/bloc/hostel/hostel_bloc.dart';

class PaymentSummerySection extends StatelessWidget {
  const PaymentSummerySection({super.key, this.extraMessage, this.extraAmount, this.discount});

  final String? extraMessage;
  final double? extraAmount;
  final double? discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          padding,
        ),
        child: Column(
          children: [
            height10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Summit hostel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: headingTextColor,
                  ),
                ),
                Text(
                  'Sun, 15 Jan',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.07,
            ),
            PaymentSummeryWidget(
              extraMessage: extraMessage,
              extraAmount: extraAmount,
              discount: discount,
            ),
            SizedBox(
              height: height * 0.1,
            ),
            CustomGreenButtonWidget(
              name: 'Go back to home',
              onPressed: () {
                context.read<HostelBloc>().add(FetchHostelsData());
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}