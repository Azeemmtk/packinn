import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/services/cloudinary_services.dart';
import 'package:packinn/core/widgets/custom_snack_bar.dart';

import '../../../../../../auth/data/model/user_model.dart';
import '../../provider/bloc/edit_profile/edit_profile_bloc.dart';

class SaveButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final File? selectedImage;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController addressController;
  final UserModel user;

  const SaveButton({
    super.key,
    required this.formKey,
    required this.selectedImage,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.ageController,
    required this.addressController,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          String? photoURL = user.photoURL;

          if (selectedImage != null) {
            try {
              final cloudinary = GetIt.instance<CloudinaryService>();
              final result = await cloudinary.uploadImage([selectedImage!]);
              if (result.isNotEmpty) {
                photoURL = result.first['secureUrl'];
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(text: 'Failed to upload image: $e', color: Colors.red),
              );
              return;
            }
          }

          final updatedUser = UserModel(
            uid: user.uid,
            email: emailController.text,
            displayName: nameController.text,
            photoURL: photoURL,
            emailVerified: user.emailVerified,
            name: null,
            phone: phoneController.text.isEmpty ? null : phoneController.text,
            phoneVerified: user.phoneVerified,
            age: int.tryParse(ageController.text),
            address: addressController.text.isEmpty ? null : addressController.text,
            role: user.role,
            profileImageUrl: null,
            walletBalance: user.walletBalance,
          );

          context.read<EditProfileBloc>().add(UpdateProfileEvent(updatedUser));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.05),
        ),
      ),
      child: const Text('Save Changes'),
    );
  }
}
