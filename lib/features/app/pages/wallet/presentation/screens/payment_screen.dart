import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/features/app/pages/wallet/presentation/provider/bloc/payment/payment_bloc.dart';
import 'package:packinn/features/app/pages/wallet/presentation/screens/payment_successful_screen.dart';
import '../../../../../../core/services/current_user.dart';
import '../../../../../../core/widgets/title_text_widget.dart';
import '../provider/bloc/payment/payment_state.dart';
import '../provider/bloc/wallet/wallet_bloc.dart';
import '../widgets/payment_summery_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    this.isBooking = false,
    this.room,
    this.id,
    required this.occupantId,
    required this.occupantName,
    required this.occupantImage,
    this.extraMessage,
    this.extraAmount,
    this.discount,
    this.registrationDate,
    this.dueDate,
    this.status = false,
  });

  final String? id;
  final bool status;
  final Map<String, dynamic>? room;
  final bool isBooking;
  final String occupantId;
  final String occupantName;
  final String occupantImage;
  final String? extraMessage;
  final double? extraAmount;
  final double? discount;
  final DateTime? dueDate;
  final DateTime? registrationDate;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'stripe'; // Default to Stripe

  @override
  Widget build(BuildContext context) {
    final String hostelId = widget.room?['hostelId'] ?? '';
    final String hostelName = widget.room?['hostelName'] ?? '';
    final String roomId = widget.room?['roomId'] ?? '';
    final String roomType = widget.room?['type'] ?? '';
    final double roomRate = (widget.room?['rate'] as num?)?.toDouble() ?? 3000.0;
    final double totalAmount = (widget.isBooking ? 100 : roomRate + (widget.extraAmount ?? 0) - (widget.discount ?? 0));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<PaymentBloc>()),
        BlocProvider(create: (context) => getIt<WalletBloc>()..add(GetWalletBalance())),
      ],
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
                  SizedBox(height: height * 0.07),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextWidget(title: 'Payment Method'),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'stripe',
                                groupValue: _paymentMethod,
                                onChanged: (value) => setState(() => _paymentMethod = value!),
                              ),
                              const Text('Stripe'),
                              Radio<String>(
                                value: 'wallet',
                                groupValue: _paymentMethod,
                                onChanged: (value) => setState(() => _paymentMethod = value!),
                              ),
                              BlocBuilder<WalletBloc, WalletState>(
                                builder: (context, state) {
                                  double balance = 0.0;
                                  if (state is WalletBalanceLoaded) balance = state.balance;
                                  return Text('Wallet (\$${balance.toStringAsFixed(2)})');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  PaymentSummeryWidget(
                    isBooking: widget.isBooking,
                    extraMessage: widget.extraMessage,
                    extraAmount: widget.extraAmount,
                    discount: widget.discount,
                    rent: roomRate,
                  ),
                  SizedBox(height: height * 0.1),
                  BlocConsumer<PaymentBloc, PaymentState>(
                    listener: (context, state) {
                      if (state is PaymentSuccess) {
                        context.read<WalletBloc>().add(GetPayments(CurrentUser().uId!));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentSuccessfulScreen(rent: roomRate),
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
                        name: widget.status
                            ? 'Go back'
                            : state is PaymentLoading
                            ? 'Processing...'
                            : 'Pay now',
                        onPressed: widget.status
                            ? () => Navigator.pop(context)
                            : state is PaymentLoading
                            ? null
                            : () {
                          if (_paymentMethod == 'wallet') {
                            final balance = context.read<WalletBloc>().state is WalletBalanceLoaded
                                ? (context.read<WalletBloc>().state as WalletBalanceLoaded).balance
                                : 0.0;
                            if (balance < totalAmount) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Insufficient wallet balance')),
                              );
                              return;
                            }
                          }
                          context.read<PaymentBloc>().add(
                            MakePaymentEvent(
                              amountToPay: totalAmount,
                              id: widget.isBooking ? null : widget.id,
                              dueDate: widget.isBooking ? null : widget.dueDate,
                              registrationDate: widget.isBooking ? null : widget.registrationDate,
                              amount: widget.isBooking ? 100 : roomRate,
                              occupantId: widget.occupantId,
                              roomType: roomType,
                              hostelId: hostelId,
                              roomId: roomId,
                              isBooking: widget.isBooking,
                              roomRate: roomRate,
                              extraMessage: widget.extraMessage,
                              extraAmount: widget.extraAmount,
                              discount: widget.discount,
                              occupantName: widget.occupantName,
                              occupantImage: widget.occupantImage,
                              hostelName: hostelName,
                              paymentMethod: _paymentMethod,
                            ),
                          );
                        },
                      );
                    },
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