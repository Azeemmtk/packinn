import 'package:flutter/material.dart';
import '../../../../../../../core/constants/const.dart';
import '../../../../../../../core/widgets/title_text_widget.dart';
import 'available_room_widget.dart';

class ReviewRoomSection extends StatelessWidget {
  const ReviewRoomSection({
    super.key,
    required this.rooms,
  });

  final List<Map<String, dynamic>> rooms;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleTextWidget(title: 'Select room for booking'),
        height10,
        ...rooms.map((room) => AvailableRoomWidget(
          room: room,
        )),
        height20,
      ],
    );
  }
}