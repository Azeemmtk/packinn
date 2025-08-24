import 'package:flutter/material.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import '../../../../../../core/constants/const.dart';
import '../../../wallet/presentation/screens/payment_screen.dart';
import '../../../../../../core/entity/occupant_entity.dart';
import '../../../../../../core/widgets/details_row_widget.dart';
import '../widgets/confirm_booking/guardian_info_section.dart';
import '../widgets/confirm_booking/id_proof_section.dart';
import '../widgets/confirm_booking/occupant_info_section.dart';
import '../widgets/confirm_booking/room_info_section.dart';

class ConfirmBookingScreen extends StatelessWidget {
  final Map<String, dynamic> room;
  final OccupantEntity occupant;

  const ConfirmBookingScreen({super.key, required this.room, required this.occupant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(title: 'Confirm booking'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoomInfoSection(room: room),
                    Divider(height: 30),
                    DetailsRowWidget(
                        title: 'Booking Charge', value: '₹ 100', isBold: true),
                    Divider(height: 30),
                    OccupantInfoSection(occupant: occupant),
                    Divider(height: 30),
                    if (occupant.guardian != null) ...[
                      GuardianInfoSection(guardian: occupant.guardian!),
                      Divider(height: 30),
                    ],
                    IdProofSection(
                      idProofUrl: occupant.idProofUrl,
                      addressProofUrl: occupant.addressProofUrl,
                      isGuardian: occupant.age < 18,
                    ),
                    height10,
                    CustomGreenButtonWidget(
                      name: 'Confirm booking',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              occupantId: occupant.id!,
                              room: room,
                              isBooking: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
