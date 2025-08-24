import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Pick an image from the gallery or camera
  Future<File?> pickImage({required bool fromCamera}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Show a bottom sheet to choose between camera and gallery
  Future<File?> showImageSourceDialog(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      backgroundColor: mainColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library,color: Colors.white,),
                title: const Text('Gallery',style: TextStyle(color: Colors.white),),
                onTap: () async {
                  final image = await pickImage(fromCamera: false);
                  Navigator.of(context).pop(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt,color: Colors.white),
                title: const Text('Camera',style: TextStyle(color: Colors.white),),
                onTap: () async {
                  final image = await pickImage(fromCamera: true);
                  Navigator.of(context).pop(image);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}