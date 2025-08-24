import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewDialog extends StatelessWidget {
  final File? image;
  final String? imageUrl;

  const ImageViewDialog({super.key, this.image, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image != null
                ? Image.file(
              image!,
              height: 300,
              fit: BoxFit.cover,
            )
                : imageUrl != null
                ? Image.network(
              imageUrl!,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Text('Failed to load image'),
            )
                : const Text('No image available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}