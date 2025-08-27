import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/services/image_picker_service.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/core/widgets/custom_text_field_widget.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/bloc/add_cooupant/add_occupant_bloc.dart';
import 'package:packinn/features/app/pages/home/presentation/widgets/confirm_booking/image_view_dialog.dart';

class AddNewOccupantSection extends StatelessWidget {
  final AddOccupantBloc addOccupantBloc;
  final OccupantFieldCubit textFieldCubit;
  final AddOccupantLoaded currentState;
  final Map<String, dynamic> room;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController guardianNameController;
  final TextEditingController guardianPhoneController;
  final TextEditingController guardianRelationController;

  const AddNewOccupantSection({
    super.key,
    required this.addOccupantBloc,
    required this.textFieldCubit,
    required this.currentState,
    required this.room,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.guardianNameController,
    required this.guardianPhoneController,
    required this.guardianRelationController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccupantFieldCubit, OccupantFieldState>(
      builder: (context, textFieldState) {
        return Column(
          children: [
            CustomTextFieldWidget(
              fieldName: 'Name',
              hintText: 'Enter name',
              controller: nameController,
              onChanged: (value) {
                textFieldCubit.updateField(name: value);
                addOccupantBloc.add(UpdateOccupantEvent(name: value));
                textFieldCubit.validateFields(isSubmitted: false);
              },
            ),
            if (textFieldState.nameError != null) ...[
              height5,
              Text(
                textFieldState.nameError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            height10,
            CustomTextFieldWidget(
              fieldName: 'Phone',
              hintText: 'Enter phone',
              controller: phoneController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                textFieldCubit.updateField(phone: value);
                addOccupantBloc.add(UpdateOccupantEvent(phone: value));
                textFieldCubit.validateFields(isSubmitted: false);
              },
            ),
            if (textFieldState.phoneError != null) ...[
              height5,
              Text(
                textFieldState.phoneError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            height10,
            CustomTextFieldWidget(
              fieldName: 'Age',
              hintText: 'Enter age',
              controller: ageController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                textFieldCubit.updateField(age: value);
                addOccupantBloc.add(UpdateOccupantEvent(age: int.tryParse(value)));
                textFieldCubit.validateFields(isSubmitted: false);
              },
            ),
            if (textFieldState.ageError != null) ...[
              height5,
              Text(
                textFieldState.ageError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            height10,
            if (int.tryParse(ageController.text) != null &&
                int.parse(ageController.text) < 18) ...[
              CustomTextFieldWidget(
                fieldName: 'Guardian Name',
                hintText: 'Enter guardian name',
                controller: guardianNameController,
                onChanged: (value) {
                  textFieldCubit.updateField(guardianName: value);
                  addOccupantBloc.add(UpdateOccupantEvent(guardianName: value));
                  textFieldCubit.validateFields(isSubmitted: false);
                },
              ),
              if (textFieldState.guardianNameError != null) ...[
                height5,
                Text(
                  textFieldState.guardianNameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              height10,
              CustomTextFieldWidget(
                fieldName: 'Guardian Phone',
                hintText: 'Enter guardian phone',
                keyboardType: TextInputType.number,
                controller: guardianPhoneController,
                onChanged: (value) {
                  textFieldCubit.updateField(guardianPhone: value);
                  addOccupantBloc.add(UpdateOccupantEvent(guardianPhone: value));
                  textFieldCubit.validateFields(isSubmitted: false);
                },
              ),
              if (textFieldState.guardianPhoneError != null) ...[
                height5,
                Text(
                  textFieldState.guardianPhoneError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              height10,
              CustomTextFieldWidget(
                fieldName: 'Guardian Relation',
                hintText: 'Enter guardian relation',
                controller: guardianRelationController,
                onChanged: (value) {
                  textFieldCubit.updateField(guardianRelation: value);
                  addOccupantBloc.add(UpdateOccupantEvent(guardianRelation: value));
                  textFieldCubit.validateFields(isSubmitted: false);
                },
              ),
              if (textFieldState.guardianRelationError != null) ...[
                height5,
                Text(
                  textFieldState.guardianRelationError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              height10,
            ],
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final image = await getIt<ImagePickerService>().showImageSourceDialog(context);
                    if (image != null) {
                      textFieldCubit.updateField(profileImage: image);
                      addOccupantBloc.add(UpdateOccupantEvent(profileImage: image));
                      textFieldCubit.validateFields(isSubmitted: false);
                    }
                  },
                  child: Text(
                      'Occupant image'),
                ),
                if (currentState.profileImage != null) ...[
                  width10,
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ImageViewDialog(image: currentState.profileImage!),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(currentState.profileImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final image =
                    await getIt<ImagePickerService>().showImageSourceDialog(context);
                    if (image != null) {
                      textFieldCubit.updateField(idProof: image);
                      addOccupantBloc.add(UpdateOccupantEvent(idProof: image));
                      textFieldCubit.validateFields(isSubmitted: false);
                    }
                  },
                  child: Text(
                      currentState.idProof == null ? 'Upload ID Proof' : 'ID Proof Uploaded'),
                ),
                if (currentState.idProof != null) ...[
                  width10,
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ImageViewDialog(image: currentState.idProof!),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(currentState.idProof!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (textFieldState.idProofError != null) ...[
              height5,
              Text(
                textFieldState.idProofError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            height10,
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final image =
                    await getIt<ImagePickerService>().showImageSourceDialog(context);
                    if (image != null) {
                      textFieldCubit.updateField(addressProof: image);
                      addOccupantBloc.add(UpdateOccupantEvent(addressProof: image));
                      textFieldCubit.validateFields(isSubmitted: false);
                    }
                  },
                  child: Text(currentState.addressProof == null
                      ? 'Upload Address Proof'
                      : 'Address Proof Uploaded'),
                ),
                if (currentState.addressProof != null) ...[
                  width10,
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ImageViewDialog(image: currentState.addressProof!),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(currentState.addressProof!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (textFieldState.addressProofError != null) ...[
              height5,
              Text(
                textFieldState.addressProofError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            height20,
            CustomGreenButtonWidget(
              name: 'Save and Continue',
              onPressed: () {
                final error = textFieldCubit.validateAndGetError();
                if (error == null) {
                  addOccupantBloc.add(SaveOccupantEvent(room));
                } else {
                  textFieldCubit.validateFields(isSubmitted: true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },
            ),
            if (currentState.occupants.isNotEmpty) ...[
              height20,
              CustomGreenButtonWidget(
                name: 'Back to Occupant List',
                onPressed: () {
                  addOccupantBloc.add(ToggleFormEvent(false));
                },
              ),
            ],
          ],
        );
      },
    );
  }
}