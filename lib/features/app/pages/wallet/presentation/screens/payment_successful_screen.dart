import 'package:flutter/material.dart';
import '../widgets/payment_success_icon_Section.dart';
import '../widgets/payment_summery_section.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  const PaymentSuccessfulScreen({super.key, required this.rent});

  final double rent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/Background.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PaymentSuccessIconSection(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: PaymentSummerySection(rent: rent,),
          )
        ],
      ),
    );
  }
}
