import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/features/app/pages/wallet/presentation/provider/bloc/payment_bloc.dart';
import 'package:packinn/features/app/pages/wallet/presentation/provider/bloc/payment_state.dart';
import 'package:packinn/features/app/pages/wallet/presentation/screens/payment_successful_screen.dart';
import '../../../../../../core/widgets/title_text_widget.dart';
import '../widgets/payment_summery_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    super.key,
    this.isBooking = false,
    this.room,
    required this.occupantId,
    required this.occupantName,
    this.extraMessage,
    this.extraAmount,
    this.discount,
  });

  final Map<String, dynamic>? room;
  final bool isBooking;
  final String occupantId;
  final String occupantName;
  final String? extraMessage;
  final double? extraAmount;
  final double? discount;

  @override
  Widget build(BuildContext context) {
    final String hostelId = room?['hostelId'] ?? '';
    final String hostelName = room?['hostelName'] ?? '';
    final String roomId = room?['roomId'] ?? '';
    final String roomType = room?['type'] ?? '';
    final double roomRate = (room?['rate'] as num?)?.toDouble() ?? 3000.0;

    return BlocProvider(
      create: (context) => getIt<PaymentBloc>(),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBarWidget(title: 'Payment'),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height10,
                  Text(
                    'Summit hostel',
                    style: TextStyle(
                      fontSize: 25,
                      color: headingTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextWidget(title: 'Due date'),
                          Text('Sun, 15 Jan')
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TitleTextWidget(title: 'Current date'),
                          Text('Sun, 15 Jan')
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                  PaymentSummeryWidget(
                    isBooking: isBooking,
                    extraMessage: extraMessage,
                    extraAmount: extraAmount,
                    discount: discount,
                  ),
                  SizedBox(
                    height: height * 0.15,
                  ),
                  BlocConsumer<PaymentBloc, PaymentState>(
                    listener: (context, state) {
                      if (state is PaymentSuccess) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentSuccessfulScreen(),
                          ),
                        );
                      } else if (state is PaymentError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: mainColor,
                            content: Text(state.message),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomGreenButtonWidget(
                        name: state is PaymentLoading ? 'Processing...' : 'Pay now',
                        onPressed: state is PaymentLoading
                            ? null
                            : () {
                          print(String.fromEnvironment('STRIPE_PUBLISHABLE_KEY'));
                          print(String.fromEnvironment('STRIPE_SECRET_KEY'));

                          context.read<PaymentBloc>().add(
                            MakePaymentEvent(
                              amount: isBooking ? 100 : roomRate,
                              occupantId: occupantId,
                              roomType: roomType,
                              hostelId: hostelId,
                              roomId: roomId,
                              isBooking: isBooking,
                              roomRate: roomRate,
                              extraMessage: extraMessage,
                              extraAmount: extraAmount,
                              discount: discount,
                              occupantName: occupantName,
                              hostelName: hostelName,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}