import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/title_text_widget.dart';
import '../../../../../../../core/entity/occupant_entity.dart';
import '../../../../../../../core/widgets/details_row_widget.dart';

class OccupantInfoSection extends StatelessWidget {
  final OccupantEntity occupant;

  const OccupantInfoSection({super.key, required this.occupant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextWidget(title: 'Occupant info'),
        height20,
        DetailsRowWidget(title: 'Name', value: occupant.name),
        height5,
        DetailsRowWidget(title: 'Phone', value: occupant.phone),
        height5,
        DetailsRowWidget(title: 'Age', value: occupant.age.toString()),
      ],
    );
  }
}