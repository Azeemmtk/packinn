import 'package:flutter/material.dart';
import 'package:packinn/features/app/pages/home/presentation/widgets/hostel_details/review_container.dart';
import '../../../../../../../core/constants/const.dart';
import '../../../../../../../core/widgets/title_text_widget.dart';
import 'available_room_widget.dart';

class ReviewRoomSection extends StatelessWidget {

   const ReviewRoomSection({super.key, required this.rooms,});

  final List<Map<String, dynamic>> rooms;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleTextWidget(title: 'Review and rating'),
        height10,
        const ReviewContainer(),
        height10,
        const ReviewContainer(),
        height20,
        const TitleTextWidget(title: 'Rooms'),
        height10,
        ...rooms.map((room) => AvailableRoomWidget(
          type: room['type'],
          count: room['count'],
          rate: room['rate'],
        )),
        height5,
        height20,
      ],
    );
  }
}