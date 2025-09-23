import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/const.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({
    super.key,
    required this.img,
  });

  final String img;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        img,
        width: double.infinity,
        height: height * 0.3,
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
    );
  }
}
