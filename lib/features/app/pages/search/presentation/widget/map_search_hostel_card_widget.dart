import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_snack_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entity/map_hostel.dart';

class MapSearchHostelCardWidget extends StatelessWidget {
  final MapHostel hostel;
  final double distance;

  const MapSearchHostelCardWidget({
    super.key,
    required this.hostel,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () async {
          final Uri googleMapsUrl = Uri.parse(
            'https://www.google.com/maps/dir/?api=1&destination=${hostel.latitude},${hostel.longitude}',
          );
          if (await canLaunchUrl(googleMapsUrl)) {
            await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(text: 'Failed to open Google Maps')
            );
          }
        },
        child: Container(
          width: width * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
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
                  imagePlaceHolder,
                  width: double.infinity,
                  height: 93,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: child,
                      );
                    }
                    return Shimmer.fromColors(
                      baseColor: secondaryColor,
                      highlightColor: mainColor,
                      direction: ShimmerDirection.ltr,
                      child: Container(
                        width: double.infinity,
                        height: 93,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hostel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      hostel.location,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // Optional: truncate location too
                    ),
                    Text(
                      'Distance - ${distance.toStringAsFixed(1)} Km',
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
        ),
      ),
    );
  }
}