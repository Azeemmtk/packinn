import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_text_field_widget.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/bloc/add_cooupant/add_occupant_bloc.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';

class EditOccupantSection extends StatelessWidget {
  final AddOccupantBloc addOccupantBloc;
  final OccupantFieldCubit textFieldCubit;
  final AddOccupantLoaded currentState;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;

  const EditOccupantSection({
    super.key,
    required this.addOccupantBloc,
    required this.textFieldCubit,
    required this.currentState,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccupantFieldCubit, OccupantFieldState>(
      builder: (context, textFieldState) {
        return Column(
          children: [
            CustomTextFieldWidget(
              controller: nameController,
              fieldName: 'Name',
              hintText: 'Name',
              errorText: textFieldState.nameError,
              onChanged: (value) {
                textFieldCubit.updateField(name: value);
                addOccupantBloc.add(UpdateOccupantEvent(
                  name: value,
                  phone: textFieldState.phone,
                  age: int.tryParse(textFieldState.age),
                  guardianName: textFieldState.guardianName,
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
              controller: phoneController,
              fieldName: 'Phone',
              hintText: 'Phone',
              errorText: textFieldState.phoneError,
              onChanged: (value) {
                textFieldCubit.updateField(phone: value);
                addOccupantBloc.add(UpdateOccupantEvent(
                  name: textFieldState.name,
                  phone: value,
                  age: int.tryParse(textFieldState.age),
                  guardianName: textFieldState.guardianName,
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
              controller: ageController,
              fieldName: 'Age',
              hintText: 'Age',
              errorText: textFieldState.ageError,
              onChanged: (value) {
                textFieldCubit.updateField(age: value);
                addOccupantBloc.add(UpdateOccupantEvent(
                  name: textFieldState.name,
                  phone: textFieldState.phone,
                  age: int.tryParse(value),
                  guardianName: textFieldState.guardianName,
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
          ],
        );
      },
    );
  }
}