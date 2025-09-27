import 'package:flutter/material.dart';
import 'package:packinn/core/entity/occupant_entity.dart';

class OccupantFormControllers {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController guardianNameController;
  final TextEditingController guardianPhoneController;
  final TextEditingController guardianRelationController;

  OccupantFormControllers(OccupantEntity occupant)
      : nameController = TextEditingController(text: occupant.name),
        phoneController = TextEditingController(text: occupant.phone),
        ageController = TextEditingController(text: occupant.age.toString()),
        guardianNameController =
        TextEditingController(text: occupant.guardian?.name ?? ''),
        guardianPhoneController =
        TextEditingController(text: occupant.guardian?.phone ?? ''),
        guardianRelationController =
        TextEditingController(text: occupant.guardian?.relation ?? '');

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    guardianNameController.dispose();
    guardianPhoneController.dispose();
    guardianRelationController.dispose();
  }
}