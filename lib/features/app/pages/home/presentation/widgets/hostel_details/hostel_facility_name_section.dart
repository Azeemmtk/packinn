import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/const.dart';
import 'facility_container.dart';

class HostelFacilityNameSection extends StatelessWidget {

  const HostelFacilityNameSection({super.key,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBSfG5TOl4RG5fvOcGZAewnVQFFtnPgLfAJu_lCJp4TAoRSOEmJNsgi723NM7KmZB48BRgjugJpo3hkiSIDfB4nyjX5gaf5A8LkkiDojl5mlWyNAVmF2SEBSNXjaqER6D5WObVHSDqWFbQgNjpr6simyF5VwUt5IEczDBe50J744_qTQmvBz4yn_g0ac-_OP-WzdTe8Ok7GSd919mhUWkLi3PjWtSD609gO5rw_57kj3Hknl5pj8efmvN1zyzrDJWwq_8JR5hHruouE',
            width: double.infinity,
            height: height * 0.3,
            fit: BoxFit.cover,
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
    FacilityContainer(facility: 'Wifi'),
            FacilityContainer(facility: 'Washing'),
            FacilityContainer(facility: 'Machine'),
            FacilityContainer(facility: 'kitchen'),
            FacilityContainer(facility: 'filter'),
            FacilityContainer(facility: 'water'),
            FacilityContainer(facility: 'Wifi'),
          ]
        ),
        height20,
        Text(
          'Summit hostel',
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
              'Netun, near temple, ernakulam',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }
}