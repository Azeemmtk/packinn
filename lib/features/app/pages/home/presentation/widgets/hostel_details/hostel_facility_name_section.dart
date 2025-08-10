import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:packinn/features/app/pages/home/domain/entity/hostel_entity.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/const.dart';
import 'facility_container.dart';

class HostelFacilityNameSection extends StatelessWidget {

  const HostelFacilityNameSection({super.key, required this.hostel,});

  final HostelEntity hostel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            hostel.mainImageUrl ?? imagePlaceHolder,
            width: double.infinity,
            height: height * 0.3,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                // Image loaded → fade in
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: child,
                );
              }

              // Show shimmer while loading
              return Shimmer.fromColors(
                baseColor: secondaryColor,
                highlightColor: mainColor,
                direction: ShimmerDirection.ltr,
                child: Container(
                  width: double.infinity,
                  height: height * 0.3,
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              height: height * 0.3,
              color: textFieldColor,
              child: const Center(child: Text('No Image')),
            ),
          ),
        ),
        height20,
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ...hostel.facilities.map((e) => FacilityContainer(facility: e),),
          ]
        ),
        height20,
        Text(
          hostel.name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: headingTextColor),
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