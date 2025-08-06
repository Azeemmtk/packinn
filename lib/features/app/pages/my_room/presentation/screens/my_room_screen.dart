import 'package:flutter/material.dart';
import '../../../../../../core/constants/const.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../widgets/custom_my_hostel_card.dart';
import 'my_room_details_screen.dart';

class MyRoomScreen extends StatelessWidget {
  const MyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppBarWidget(
            title: 'My Hostels',
            enableChat: true,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: padding, right: padding),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyRoomDetailsScreen(),
                        ),
                      );
                    },
                    child: CustomMyHostelCard(
                      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBSfG5TOl4RG5fvOcGZAewnVQFFtnPgLfAJu_lCJp4TAoRSOEmJNsgi723NM7KmZB48BRgjugJpo3hkiSIDfB4nyjX5gaf5A8LkkiDojl5mlWyNAVmF2SEBSNXjaqER6D5WObVHSDqWFbQgNjpr6simyF5VwUt5IEczDBe50J744_qTQmvBz4yn_g0ac-_OP-WzdTe8Ok7GSd919mhUWkLi3PjWtSD609gO5rw_57kj3Hknl5pj8efmvN1zyzrDJWwq_8JR5hHruouE',
                      title: 'Summit hostel',
                      location: 'Netur, near temple, ernakulam',
                      rent: 4000,
                      rating: 5.0, // Placeholder
                      distance: 0, // Placeholder
                      approved: true, // New field
                    ),
                  );
                },
                separatorBuilder: (context, index) => height10,
                itemCount: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
