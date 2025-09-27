import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_snack_bar.dart';
import 'package:packinn/core/entity/occupant_entity.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';
import '../../provider/bloc/add_cooupant/add_occupant_bloc.dart';
import '../../widgets/edit_occupant/edit_guardian_section.dart';
import '../../widgets/edit_occupant/edit_image_section.dart';
import '../../widgets/edit_occupant/edit_occupant_section.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';

import 'occupant_form_controllers.dart';

class EditOccupantForm extends StatelessWidget {
  final OccupantEntity occupant;
  final Map<String, dynamic> room;
  final OccupantFormControllers controllers;

  const EditOccupantForm({
    super.key,
    required this.occupant,
    required this.room,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddOccupantBloc, AddOccupantState>(
      listener: (context, state) {
        if (state is AddOccupantSuccess) {
          Navigator.pop(context, true);
        } else if (state is AddOccupantError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(text: state.message),
          );
        }
      },
      builder: (context, state) {
        return BlocBuilder<OccupantFieldCubit, OccupantFieldState>(
          builder: (context, textFieldState) {
            final addOccupantBloc = context.read<AddOccupantBloc>();
            final textFieldCubit = context.read<OccupantFieldCubit>();
            final currentState = state is AddOccupantLoaded
                ? state
                : AddOccupantLoaded(
              name: textFieldState.name,
              phone: textFieldState.phone,
              age: int.tryParse(textFieldState.age),
              guardianName: textFieldState.guardianName,
              guardianPhone: textFieldState.guardianPhone,
              guardianRelation: textFieldState.guardianRelation,
              idProof: null,
              addressProof: null,
              idProofUrl: occupant.idProofUrl,
              addressProofUrl: occupant.addressProofUrl,
              occupants: [],
              showForm: true,
            );

            // Update controllers only if the text field state changes
            if (controllers.nameController.text != textFieldState.name) {
              controllers.nameController.text = textFieldState.name;
            }
            if (controllers.phoneController.text != textFieldState.phone) {
              controllers.phoneController.text = textFieldState.phone;
            }
            if (controllers.ageController.text != textFieldState.age) {
              controllers.ageController.text = textFieldState.age;
            }
            if (controllers.guardianNameController.text !=
                textFieldState.guardianName) {
              controllers.guardianNameController.text =
                  textFieldState.guardianName;
            }
            if (controllers.guardianPhoneController.text !=
                textFieldState.guardianPhone) {
              controllers.guardianPhoneController.text =
                  textFieldState.guardianPhone;
            }
            if (controllers.guardianRelationController.text !=
                textFieldState.guardianRelation) {
              controllers.guardianRelationController.text =
                  textFieldState.guardianRelation;
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EditOccupantSection(
                          addOccupantBloc: addOccupantBloc,
                          textFieldCubit: textFieldCubit,
                          currentState: currentState,
                          nameController: controllers.nameController,
                          phoneController: controllers.phoneController,
                          ageController: controllers.ageController,
                        ),
                        EditGuardianSection(
                          addOccupantBloc: addOccupantBloc,
                          textFieldCubit: textFieldCubit,
                          currentState: currentState,
                          guardianNameController:
                          controllers.guardianNameController,
                          guardianPhoneController:
                          controllers.guardianPhoneController,
                          guardianRelationController:
                          controllers.guardianRelationController,
                          ageText: controllers.ageController.text,
                        ),
                        EditImageSection(
                          addOccupantBloc: addOccupantBloc,
                          textFieldCubit: textFieldCubit,
                          currentState: currentState,
                        ),
                        CustomGreenButtonWidget(
                          name: 'Save and Continue',
                          onPressed: () {
                            final error = textFieldCubit.validateAndGetError();
                            if (error == null) {
                              addOccupantBloc.add(SaveOccupantEvent(
                                room,
                                occupantId: occupant.id,
                              ));
                            } else {
                              textFieldCubit.validateFields(isSubmitted: true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                customSnackBar(text: error, color: Colors.red),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is AddOccupantLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}