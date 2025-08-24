import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_text_field_widget.dart';
import 'package:packinn/core/widgets/title_text_widget.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/bloc/add_cooupant/add_occupant_bloc.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';

class EditGuardianSection extends StatelessWidget {
  final AddOccupantBloc addOccupantBloc;
  final OccupantFieldCubit textFieldCubit;
  final AddOccupantLoaded currentState;
  final TextEditingController guardianNameController;
  final TextEditingController guardianPhoneController;
  final TextEditingController guardianRelationController;
  final String ageText;

  const EditGuardianSection({
    super.key,
    required this.addOccupantBloc,
    required this.textFieldCubit,
    required this.currentState,
    required this.guardianNameController,
    required this.guardianPhoneController,
    required this.guardianRelationController,
    required this.ageText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccupantFieldCubit, OccupantFieldState>(
      builder: (context, textFieldState) {
        if (int.tryParse(ageText) != null && int.tryParse(ageText)! < 18) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleTextWidget(title: 'Guardian Details'),
              height10,
              CustomTextFieldWidget(
                controller: guardianNameController,
                fieldName: 'Guardian Name',
                hintText: 'Guardian Name',
                errorText: textFieldState.guardianNameError,
                onChanged: (value) {
                  textFieldCubit.updateField(guardianName: value);
                  addOccupantBloc.add(UpdateOccupantEvent(
                    name: textFieldState.name,
                    phone: textFieldState.phone,
                    age: int.tryParse(textFieldState.age),
                    guardianName: value,
                    guardianPhone: textFieldState.guardianPhone,
                    guardianRelation: textFieldState.guardianRelation,
                    idProof: currentState.idProof,
                    addressProof: currentState.addressProof,
                    idProofUrl: currentState.idProofUrl,
                    addressProofUrl: currentState.addressProofUrl,
                  ));
                  textFieldCubit.validateFields(isSubmitted: false);
                },
              ),
              height10,
              CustomTextFieldWidget(
                controller: guardianPhoneController,
                fieldName: 'Guardian Phone',
                hintText: 'Guardian Phone',
                errorText: textFieldState.guardianPhoneError,
                onChanged: (value) {
                  textFieldCubit.updateField(guardianPhone: value);
                  addOccupantBloc.add(UpdateOccupantEvent(
                    name: textFieldState.name,
                    phone: textFieldState.phone,
                    age: int.tryParse(textFieldState.age),
                    guardianName: textFieldState.guardianName,
                    guardianPhone: value,
                    guardianRelation: textFieldState.guardianRelation,
                    idProof: currentState.idProof,
                    addressProof: currentState.addressProof,
                    idProofUrl: currentState.idProofUrl,
                    addressProofUrl: currentState.addressProofUrl,
                  ));
                  textFieldCubit.validateFields(isSubmitted: false);
                },
              ),
              height10,
              CustomTextFieldWidget(
                controller: guardianRelationController,
                fieldName: 'Guardian Relation',
                hintText: 'Guardian Relation',
                errorText: textFieldState.guardianRelationError,
                onChanged: (value) {
                  textFieldCubit.updateField(guardianRelation: value);
                  addOccupantBloc.add(UpdateOccupantEvent(
                    name: textFieldState.name,
                    phone: textFieldState.phone,
                    age: int.tryParse(textFieldState.age),
                    guardianName: textFieldState.guardianName,
                    guardianPhone: textFieldState.guardianPhone,
                    guardianRelation: value,
                    idProof: currentState.idProof,
                    addressProof: currentState.addressProof,
                    idProofUrl: currentState.idProofUrl,
                    addressProofUrl: currentState.addressProofUrl,
                  ));
                  textFieldCubit.validateFields(isSubmitted: false);
                },
              ),
              height10,
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}