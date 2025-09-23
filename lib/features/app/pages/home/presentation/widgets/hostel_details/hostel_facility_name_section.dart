import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packinn/core/widgets/main_image_container.dart';
import 'package:packinn/core/entity/hostel_entity.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/const.dart';
import 'facility_container.dart';

class HostelFacilityNameSection extends StatelessWidget {
  const HostelFacilityNameSection({super.key, required this.hostel});

  final HostelEntity hostel;

  @override
  Widget build(BuildContext context) {
    // Combine main image and small images into a single list
    final List<String> allImages = [
      if (hostel.mainImageUrl != null) hostel.mainImageUrl!,
      ...hostel.smallImageUrls,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainImageContainer(images: allImages),
        height20,
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ...hostel.facilities.map((e) => FacilityContainer(facility: e)),
          ],
        ),
        height20,
        Text(
          hostel.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: headingTextColor,
          ),
        ),
        Row(
          children: [
            Icon(
              FontAwesomeIcons.locationDot,
              color: mainColor,
              size: 22,
            ),
            Text(
              hostel.placeName,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}