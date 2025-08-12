import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:packinn/features/app/pages/home/domain/entity/hostel_entity.dart';

import '../../../../../../../core/constants/const.dart';
import '../../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../../../../../../../core/widgets/custom_green_button_widget.dart';
import '../../../home/presentation/widgets/hostel_details/description_preview_section.dart';
import '../../../home/presentation/widgets/hostel_details/hostel_facility_name_section.dart';
import '../../../home/presentation/widgets/hostel_details/review_room_section.dart';

class MyRoomDetailsScreen extends StatelessWidget {
  const MyRoomDetailsScreen({
    super.key,
    required this.hostel,
  });

  final HostelEntity hostel;

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBSfG5TOl4RG5fvOcGZAewnVQFFtnPgLfAJu_lCJp4TAoRSOEmJNsgi723NM7KmZB48BRgjugJpo3hkiSIDfB4nyjX5gaf5A8LkkiDojl5mlWyNAVmF2SEBSNXjaqER6D5WObVHSDqWFbQgNjpr6simyF5VwUt5IEczDBe50J744_qTQmvBz4yn_g0ac-_OP-WzdTe8Ok7GSd919mhUWkLi3PjWtSD609gO5rw_57kj3Hknl5pj8efmvN1zyzrDJWwq_8JR5hHruouE',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBSfG5TOl4RG5fvOcGZAewnVQFFtnPgLfAJu_lCJp4TAoRSOEmJNsgi723NM7KmZB48BRgjugJpo3hkiSIDfB4nyjX5gaf5A8LkkiDojl5mlWyNAVmF2SEBSNXjaqER6D5WObVHSDqWFbQgNjpr6simyF5VwUt5IEczDBe50J744_qTQmvBz4yn_g0ac-_OP-WzdTe8Ok7GSd919mhUWkLi3PjWtSD609gO5rw_57kj3Hknl5pj8efmvN1zyzrDJWwq_8JR5hHruouE',
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBSfG5TOl4RG5fvOcGZAewnVQFFtnPgLfAJu_lCJp4TAoRSOEmJNsgi723NM7KmZB48BRgjugJpo3hkiSIDfB4nyjX5gaf5A8LkkiDojl5mlWyNAVmF2SEBSNXjaqER6D5WObVHSDqWFbQgNjpr6simyF5VwUt5IEczDBe50J744_qTQmvBz4yn_g0ac-_OP-WzdTe8Ok7GSd919mhUWkLi3PjWtSD609gO5rw_57kj3Hknl5pj8efmvN1zyzrDJWwq_8JR5hHruouE'
    ];
    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(
            title: 'hostel name',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HostelFacilityNameSection(
                      hostel: hostel,
                    ),
                    DescriptionPreviewSection(
                      hostel: hostel,
                    ),
                    ReviewRoomSection(
                      rooms: [
                        {
                          'type': 'Ac',
                          'count': 7,
                          'rate': 2500.0,
                        },
                        {
                          'type': 'Ac',
                          'count': 7,
                          'rate': 2500.0,
                        },
                      ],
                    ),
                    Row(
                      children: [
                        // Text(
                        //   'Status: ${hostel.approved ? 'Approved' : 'Pending'}',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     color: hostel.approved ? Colors.green : Colors.red,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ],
                    ),
                    height20,
                    CustomGreenButtonWidget(
                      name: 'Add review',
                      onPressed: () {
                        // TODO: Implement edit functionality
                      },
                    ),
                    height20,
                    CustomGreenButtonWidget(
                      name: 'Report',
                      color: Colors.redAccent,
                      onPressed: () {
                        // TODO: Implement delete functionality
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
