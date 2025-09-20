import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../../home/domain/entity/report_entity.dart';

class ReportCardWidget extends StatelessWidget {
  const ReportCardWidget({
    super.key,
    required this.report,
  });

  final ReportEntity report;

  @override
  Widget build(BuildContext context) {
    print(report.imageUrl);
    return Card(
      elevation: 4.0,
      color: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  report.imageUrl!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if(loadingProgress == null){
                      return child;
                    }
                    return Shimmer.fromColors(
                        baseColor: mainColor,
                        highlightColor: secondaryColor,
                        child: Container(
                          height: 200,
                          width: 200,
                          color: Colors.white,
                        ));
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    width: 200,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),

                ),
              ),
            if (report.imageUrl != null)
              const SizedBox(height: 12.0),
            Text(
              'Message:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              report.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12.0),
            Text(
              'Status:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              report.status,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (report.adminAction != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Action:',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      report.adminAction!,
                      style:
                      Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
