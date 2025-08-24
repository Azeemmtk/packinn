import 'package:flutter/material.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/title_text_widget.dart';
import '../../../../../../../core/entity/occupant_entity.dart';
import '../../../../../../../core/widgets/details_row_widget.dart';

class GuardianInfoSection extends StatelessWidget {
  final GuardianEntity guardian;

  const GuardianInfoSection({super.key, required this.guardian});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextWidget(title: 'Guardian info'),
        height20,
        DetailsRowWidget(title: 'Name', value: guardian.name),
        height5,
        DetailsRowWidget(title: 'Phone', value: guardian.phone),
        height5,
        DetailsRowWidget(title: 'Relation', value: guardian.relation),
      ],
    );
  }
}