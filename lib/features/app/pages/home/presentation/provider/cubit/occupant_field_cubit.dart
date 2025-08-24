import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'occupant_field_state.dart';

class OccupantFieldCubit extends Cubit<OccupantFieldState> {
  OccupantFieldCubit() : super(OccupantFieldState());

  void updateField({
    String? name,
    String? phone,
    String? age,
    String? guardianName,
    String? guardianPhone,
    String? guardianRelation,
    File? idProof,
    File? addressProof,
    String? idProofUrl,
    String? addressProofUrl,
  }) {
    emit(OccupantFieldState(
      name: name ?? state.name,
      phone: phone ?? state.phone,
      age: age ?? state.age,
      guardianName: guardianName ?? state.guardianName,
      guardianPhone: guardianPhone ?? state.guardianPhone,
      guardianRelation: guardianRelation ?? state.guardianRelation,
      idProof: idProof ?? state.idProof,
      addressProof: addressProof ?? state.addressProof,
      idProofUrl: idProofUrl ?? state.idProofUrl,
      addressProofUrl: addressProofUrl ?? state.addressProofUrl,
      nameError: state.nameError,
      phoneError: state.phoneError,
      ageError: state.ageError,
      guardianNameError: state.guardianNameError,
      guardianPhoneError: state.guardianPhoneError,
      guardianRelationError: state.guardianRelationError,
      idProofError: state.idProofError,
      addressProofError: state.addressProofError,
    ));
  }

  bool validateFields({required bool isSubmitted}) {
    String? nameError;
    String? phoneError;
    String? ageError;
    String? guardianNameError;
    String? guardianPhoneError;
    String? guardianRelationError;
    String? idProofError;
    String? addressProofError;

    if (isSubmitted) {
      if (state.name.isEmpty) {
        nameError = 'Name is required';
      }
      if (state.phone.isEmpty) {
        phoneError = 'Phone is required';
      }
      if (state.age.isEmpty) {
        ageError = 'Age is required';
      } else {
        final age = int.tryParse(state.age);
        if (age == null) {
          ageError = 'Age must be a valid number';
        } else if (age < 18) {
          if (state.guardianName.isEmpty) {
            guardianNameError = 'Guardian Name is required';
          }
          if (state.guardianPhone.isEmpty) {
            guardianPhoneError = 'Guardian Phone is required';
          }
          if (state.guardianRelation.isEmpty) {
            guardianRelationError = 'Guardian Relation is required';
          }
          if (state.idProof == null && state.idProofUrl == null) {
            idProofError = 'Guardian ID Proof is required';
          }
          if (state.addressProof == null && state.addressProofUrl == null) {
            addressProofError = 'Guardian Address Proof is required';
          }
        } else {
          if (state.idProof == null && state.idProofUrl == null) {
            idProofError = 'Occupant ID Proof is required';
          }
          if (state.addressProof == null && state.addressProofUrl == null) {
            addressProofError = 'Occupant Address Proof is required';
          }
        }
      }
    }

    emit(OccupantFieldState(
      name: state.name,
      phone: state.phone,
      age: state.age,
      guardianName: state.guardianName,
      guardianPhone: state.guardianPhone,
      guardianRelation: state.guardianRelation,
      idProof: state.idProof,
      addressProof: state.addressProof,
      idProofUrl: state.idProofUrl,
      addressProofUrl: state.addressProofUrl,
      nameError: nameError,
      phoneError: phoneError,
      ageError: ageError,
      guardianNameError: guardianNameError,
      guardianPhoneError: guardianPhoneError,
      guardianRelationError: guardianRelationError,
      idProofError: idProofError,
      addressProofError: addressProofError,
    ));

    return nameError == null &&
        phoneError == null &&
        ageError == null &&
        guardianNameError == null &&
        guardianPhoneError == null &&
        guardianRelationError == null &&
        idProofError == null &&
        addressProofError == null;
  }

  String? validateAndGetError() {
    if (state.name.isEmpty) {
      return 'Please fill all required occupant fields';
    }
    if (state.phone.isEmpty) {
      return 'Please fill all required occupant fields';
    }
    if (state.age.isEmpty) {
      return 'Please fill all required occupant fields';
    }
    final age = int.tryParse(state.age);
    if (age == null) {
      return 'Age must be a valid number';
    }
    if (age < 18) {
      if (state.guardianName.isEmpty ||
          state.guardianPhone.isEmpty ||
          state.guardianRelation.isEmpty) {
        return 'Please fill all required guardian fields';
      }
      if (state.idProof == null && state.idProofUrl == null) {
        return 'Please upload ID proof for guardian';
      }
      if (state.addressProof == null && state.addressProofUrl == null) {
        return 'Please upload address proof for guardian';
      }
    } else {
      if (state.idProof == null && state.idProofUrl == null) {
        return 'Please upload ID proof for occupant';
      }
      if (state.addressProof == null && state.addressProofUrl == null) {
        return 'Please upload address proof for occupant';
      }
    }
    return null;
  }
}