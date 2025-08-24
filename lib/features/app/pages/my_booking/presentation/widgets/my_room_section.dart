import 'package:flutter/material.dart';
import 'package:packinn/features/app/pages/my_booking/presentation/widgets/my_room_details_widget.dart';
import '../../../../../../../core/constants/const.dart';
import '../../../../../../../core/widgets/title_text_widget.dart';

class MyRoomSection extends StatelessWidget {
  const MyRoomSection({
    super.key,
    required this.room,
  });

  final Map<String, dynamic> room;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const TitleTextWidget(title: 'Review and rating'),
        // height10,
        // const ReviewContainer(),
        // height10,
        // const ReviewContainer(),
        // height20,
        const TitleTextWidget(title: 'You\'r room'),
        height10,
        MyRoomDetailsWidget(room: room),
      ],
    );
  }
}
