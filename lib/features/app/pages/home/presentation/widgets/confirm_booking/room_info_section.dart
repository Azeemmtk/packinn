import 'package:flutter/material.dart';

import '../../../../../../../core/constants/const.dart';
import '../../../../../../../core/widgets/main_image_container.dart';
import '../../../../../../../core/widgets/title_text_widget.dart';
import '../../../../../../../core/widgets/details_row_widget.dart';

class RoomInfoSection extends StatelessWidget {
  const RoomInfoSection({super.key, required this.room});

  final Map<String, dynamic> room;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainImageContainer(
          img: room['img'] ?? imagePlaceHolder,
        ),
        height20,
        TitleTextWidget(title: 'Room Info'),
        height10,
        DetailsRowWidget(title: 'Room type', value: room['type']),
        height5,
        DetailsRowWidget(
            title:
            room['type'] == 'Single' ? 'No of rooms' : 'No of Beds',
            value: room['count'].toString()),
        height5,
        DetailsRowWidget(
            title: 'Rent', value: room['rate'].toString()),
        height5,
        DetailsRowWidget(title: 'Advance', value: '₹ 5000'),
      ],
    );
  }
}
