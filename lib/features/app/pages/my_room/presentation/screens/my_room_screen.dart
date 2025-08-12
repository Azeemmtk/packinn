import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:packinn/features/app/pages/home/domain/entity/hostel_entity.dart';
import '../../../../../../core/constants/const.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../../../home/data/model/hostel_model.dart';
import '../widgets/custom_my_hostel_card.dart';
import 'my_room_details_screen.dart';

class MyRoomScreen extends StatelessWidget {
  const MyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final data= {
      "approved": true,
      "contactNumber": "2589632548",
      "createdAt": Timestamp.fromDate(DateTime.parse("2025-08-05T10:30:30+05:30")),
      "description": "good hostel in the evening I am going to be a story",
      "facilities": [
        "ac",
        "washing machine"
      ],
      "id": "6f2c6323-4b5e-4289-aecd-6619adbda2b1",
      "latitude": 9.9382162,
      "longitude": 76.3218239,
      "mainImagePublicId": "hostels/i8qddaad7gpu6lq3t2zw",
      "mainImageUrl": "https://res.cloudinary.com/dtxzelelh/image/upload/v1754369914/hostels/i8qddaad7gpu6lq3t2zw.jpg",
      "name": "sumith hostel ",
      "ownerId": "nrOJ87UBxWSH5BsokafiMFgt8A93",
      "ownerName": "",
      "placeName": "Kochi, Kerala, India",
      "rooms": [
        {
          "count": 9,
          "rate": 5800,
          "type": "single room"
        }
      ],
      "smallImagePublicIds": [
        "hostels/bdpasaclrsdutvadrotl"
      ],
      "smallImageUrls": [
        "https://res.cloudinary.com/dtxzelelh/image/upload/v1754370029/hostels/bdpasaclrsdutvadrotl.jpg"
      ],
      "databaseLocation": "asia-southeast1"
    };
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
                          builder: (context) => MyRoomDetailsScreen(hostel: HostelModel.fromJson(data) as HostelEntity,),
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
