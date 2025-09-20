import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../core/constants/colors.dart';

class BuildSmallHostelCard extends StatelessWidget {
  const BuildSmallHostelCard({super.key,
    required this.imageUrl,
    required this.title,
    required this.rent,
    required this.distance,
  });

  final String imageUrl;
  final String title;
  final double rent;
  final String distance;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 96,
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
                    height: 96,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Shimmer.fromColors(
                  baseColor: secondaryColor,
                  highlightColor: mainColor,
                  direction: ShimmerDirection.ltr,
                  child: Container(
                    width: double.infinity,
                    height: 96,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'RENT - $rent',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Distance - $distance',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
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

