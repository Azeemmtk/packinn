import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final File? selectedImage;
  final String? photoURL;
  final VoidCallback onPickImage;

  const ProfileImageWidget({
    super.key,
    required this.selectedImage,
    required this.photoURL,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: selectedImage != null
              ? FileImage(selectedImage!)
              : (photoURL != null ? NetworkImage(photoURL!) : null) as ImageProvider?,
          child: (selectedImage == null && photoURL == null)
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        TextButton(
          onPressed: onPickImage,
          child: const Text('Change Profile Image'),
        ),
      ],
    );
  }
}
