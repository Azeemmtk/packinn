import 'dart:io';

import 'package:flutter/material.dart';
import 'package:packinn/core/constants/const.dart';

import '../../../../../../../core/constants/colors.dart';

class ImageButton extends StatelessWidget {
  final String label;
  final String title;
  final File? image;
  final VoidCallback onPressed;
  final VoidCallback? onImageTap;

  const ImageButton({
    super.key,
    required this.label,
    required this.title,
    this.image,
    required this.onPressed,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13),
          ),
          height5,
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: mainColor, width: 2),
                  color: image == null ? mainColor : null,
                  image: image != null
                      ? DecorationImage(
                          image: FileImage(image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: image == null
                    ? Center(
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : null,
              ),
              if (image != null)
                Positioned(
                  top: -10,
                  right: -7,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.transparent, // Optional for transparent background
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white, // Dialog background
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.file(
                              image!, // your image file
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: mainColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
