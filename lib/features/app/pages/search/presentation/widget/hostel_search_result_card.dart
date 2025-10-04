import 'package:flutter/material.dart';
import '../../../../../../core/constants/const.dart';
import '../../../../../../core/entity/hostel_entity.dart';


class HostelSearchResultCard extends StatelessWidget {
  final HostelEntity hostel;

  const HostelSearchResultCard({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              hostel.mainImageUrl ?? imagePlaceHolder,
              width: width * 0.4,
              height: height * 0.14,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.network(
                imagePlaceHolder,
                width: width * 0.4,
                height: height * 0.14,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      (hostel.rating ?? 0.0).toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      hostel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    width5,
                    Text(
                      '(3 KM)',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  hostel.placeName,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'RENT - ${hostel.rooms.isNotEmpty ? hostel.rooms[0]['rate'] ?? 'N/A' : 'N/A'} /MONTH',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}