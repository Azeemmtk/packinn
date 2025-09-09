import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/services/image_picker_service.dart';
import 'package:packinn/core/widgets/custom_text_field_widget.dart';
import 'package:packinn/features/app/pages/account/presentation/widgets/edit/profile_image_widget.dart';
import 'package:packinn/features/app/pages/account/presentation/widgets/edit/save_button.dart';

import '../../screens/edit_profile_Screen.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = (context.findAncestorWidgetOfExactType<EditProfileScreen>() as EditProfileScreen).user;

    _nameController = TextEditingController(text: user.displayName ?? '');
    _emailController = TextEditingController(text: user.email ?? '');
    _phoneController = TextEditingController(text: user.phone ?? '');
    _ageController = TextEditingController(text: user.age?.toString() ?? '');
    _addressController = TextEditingController(text: user.address ?? '');
  }

  Future<void> _pickImage() async {
    final imagePicker = GetIt.instance<ImagePickerService>();
    final image = await imagePicker.showImageSourceDialog(context);
    if (image != null) setState(() => _selectedImage = image);
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.findAncestorWidgetOfExactType<EditProfileScreen>() as EditProfileScreen).user;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          ProfileImageWidget(
            selectedImage: _selectedImage,
            photoURL: user.photoURL,
            onPickImage: _pickImage,
          ),
          SizedBox(height: height * 0.02),
          CustomTextFieldWidget(
            hintText: 'Enter name',
            fieldName: 'Name',
            controller: _nameController,
            validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
          ),
          SizedBox(height: height * 0.02),
          CustomTextFieldWidget(
            hintText: 'Enter email',
            fieldName: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: height * 0.02),
          CustomTextFieldWidget(
            hintText: 'Enter phone',
            fieldName: 'Phone',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: height * 0.02),
          CustomTextFieldWidget(
            hintText: 'Enter age',
            fieldName: 'Age',
            controller: _ageController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: height * 0.02),
          CustomTextFieldWidget(
            hintText: 'Enter address',
            fieldName: 'Address',
            controller: _addressController,
            expanded: true,
          ),
          SizedBox(height: height * 0.02),
          SaveButton(
            formKey: _formKey,
            selectedImage: _selectedImage,
            nameController: _nameController,
            emailController: _emailController,
            phoneController: _phoneController,
            ageController: _ageController,
            addressController: _addressController,
            user: user,
          ),
        ],
      ),
    );
  }
}
