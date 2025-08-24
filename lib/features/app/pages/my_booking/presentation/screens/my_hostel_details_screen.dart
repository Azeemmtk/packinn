import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packinn/core/entity/hostel_entity.dart';
import 'package:packinn/features/app/pages/my_booking/presentation/widgets/my_room_section.dart';

import '../../../../../../../core/constants/const.dart';
import '../../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../../../../../../../core/widgets/custom_green_button_widget.dart';
import '../../../home/presentation/widgets/hostel_details/description_preview_section.dart';
import '../../../home/presentation/widgets/hostel_details/hostel_facility_name_section.dart';
import '../../../home/presentation/widgets/hostel_details/review_room_section.dart';

class MyHostelDetailsScreen extends StatelessWidget {
  const MyHostelDetailsScreen({
    super.key,
    required this.hostel,
    required this.room,
    required this.occupantName,
  });

  final HostelEntity hostel;
  final Map<String, dynamic> room;
  final String occupantName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(
            title: hostel.name,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HostelFacilityNameSection(
                      hostel: hostel,
                    ),
                    DescriptionPreviewSection(
                      hostel: hostel,
                    ),
                    MyRoomSection(
                      room: room,
                    ),
                    height20,
                    CustomGreenButtonWidget(
                      name: 'Review and ratings',
                      onPressed: () {
                      },
                    ),
                    height20,
                    CustomGreenButtonWidget(
                      name: 'Report',
                      color: Colors.redAccent,
                      onPressed: () {
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
