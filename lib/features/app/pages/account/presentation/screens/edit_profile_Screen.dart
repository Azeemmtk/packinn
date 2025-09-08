import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/services/cloudinary_services.dart';
import 'package:packinn/core/services/image_picker_service.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/core/widgets/custom_text_field_widget.dart';
import 'dart:io';

import '../../../../../auth/data/model/user_model.dart';
import '../provider/bloc/edit_profile/edit_profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _addressController;
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final editProfileBloc = GetIt.instance<EditProfileBloc>(); // Retrieve once at initialization

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _ageController = TextEditingController(text: widget.user.age?.toString() ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final imagePicker = GetIt.instance<ImagePickerService>();
      final image = await imagePicker.showImageSourceDialog(context);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: editProfileBloc,
      child: Builder(
        builder: (innerContext) => Scaffold(
          body: BlocListener<EditProfileBloc, EditProfileState>(
            listener: (innerContext, state) {
              if (state is EditProfileSuccess) {
                ScaffoldMessenger.of(innerContext).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(innerContext, true);
              } else if (state is EditProfileError) {
                ScaffoldMessenger.of(innerContext).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const CustomAppBarWidget(title: 'Edit Profile'),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Profile Image Section
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                      : (widget.user.photoURL != null
                                      ? NetworkImage(widget.user.photoURL!)
                                      : null),
                                  child: (_selectedImage == null && widget.user.photoURL == null)
                                      ? const Icon(Icons.person, size: 50)
                                      : null,
                                ),
                                TextButton(
                                  onPressed: _pickAndUploadImage,
                                  child: const Text('Change Profile Image'),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            CustomTextFieldWidget(
                              hintText: 'Enter name',
                              fieldName: 'Name',
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: height * 0.02),
                            CustomTextFieldWidget(
                              hintText: 'Enter email',
                              fieldName: 'Email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
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
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final phone = value.replaceAll(RegExp(r'\D'), '');
                                  if (phone.length < 10) {
                                    return 'Enter a valid phone number';
                                  }
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: height * 0.02),
                            CustomTextFieldWidget(
                              hintText: 'Enter age',
                              fieldName: 'Age',
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final age = int.tryParse(value);
                                  if (age == null || age < 0 || age > 150) {
                                    return 'Enter a valid age';
                                  }
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: height * 0.02),
                            CustomTextFieldWidget(
                              hintText: 'Enter address',
                              fieldName: 'Address',
                              controller: _addressController,
                              expanded: true,
                            ),
                            SizedBox(height: height * 0.02),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  String? photoURL = widget.user.photoURL;
                                  if (_selectedImage != null) {
                                    try {
                                      final cloudinary = GetIt.instance<CloudinaryService>();
                                      final result = await cloudinary.uploadImage([_selectedImage!]);
                                      if (result.isNotEmpty) {
                                        photoURL = result.first['secureUrl'];
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(innerContext).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to upload image: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                  }
                                  final updatedUser = UserModel(
                                    uid: widget.user.uid,
                                    email: _emailController.text,
                                    displayName: _nameController.text,
                                    photoURL: photoURL,
                                    emailVerified: widget.user.emailVerified,
                                    name: null, // Removed as per requirement
                                    phone: _phoneController.text.isEmpty ? null : _phoneController.text,
                                    phoneVerified: widget.user.phoneVerified,
                                    age: int.tryParse(_ageController.text),
                                    address: _addressController.text.isEmpty ? null : _addressController.text,
                                    role: widget.user.role,
                                    profileImageUrl: null, // Set to null as photoURL is used
                                    walletBalance: widget.user.walletBalance,
                                  );
                                  innerContext.read<EditProfileBloc>().add(UpdateProfileEvent(updatedUser)); // Use innerContext
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}