import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/services/image_picker_service.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/core/widgets/custom_snack_bar.dart';
import 'package:packinn/core/widgets/custom_text_field_widget.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/bloc/add_cooupant/add_occupant_bloc.dart';
import 'package:packinn/features/app/pages/home/presentation/widgets/confirm_booking/image_view_dialog.dart';

import 'image_add_section.dart';
import 'image_button.dart';



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
            height20,
            ImageAddSection(
              addOccupantBloc: addOccupantBloc,
              textFieldCubit: textFieldCubit,
              currentState: currentState,
            ),
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
                    customSnackBar(text: error, color: Colors.red),
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