import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packinn/core/utils/enums.dart';
import 'package:packinn/features/app/pages/home/domain/entity/hostel_entity.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/const.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../../../../../../core/widgets/custom_green_button_widget.dart';
import '../widgets/hostel_details/description_preview_section.dart';
import '../widgets/hostel_details/hostel_facility_name_section.dart';
import '../widgets/hostel_details/review_room_section.dart';

class HostelDetailsScreen extends StatelessWidget {

  const HostelDetailsScreen({super.key, required this.hostel,});
  final HostelEntity hostel;

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
                    HostelFacilityNameSection(hostel: hostel,),
                    DescriptionPreviewSection(
                      hostel: hostel,
                    ),
                    ReviewRoomSection(
                      rooms: hostel.rooms,
                    ),
                    Row(
                      children: [
                        Text(
                          'Status: ${hostel.status.value}',
                          style: TextStyle(
                            fontSize: 16,
                            color: hostel.status == Status.approved
                                ? mainColor
                                : hostel.status == Status.blocked
                                ? Colors.grey
                                : hostel.status == Status.rejected
                                ? Colors.red
                                : Colors.orange
                            ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    height20,
                    CustomGreenButtonWidget(
                      name: 'Book Now',
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
