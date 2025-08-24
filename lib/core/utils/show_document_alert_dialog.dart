import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

void showDocumentAlertDialog(BuildContext context, String title, String imageUrl) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: textFieldColor,
      title: Text(title),
      content: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, size: 60),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}