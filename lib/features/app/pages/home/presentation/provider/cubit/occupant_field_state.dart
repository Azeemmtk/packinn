part of 'occupant_field_cubit.dart';

class OccupantFieldState extends Equatable {
  final String name;
  final String phone;
  final String age;
  final String guardianName;
  final String guardianPhone;
  final String guardianRelation;
  final File? idProof;
  final File? addressProof;
  final String? idProofUrl;
  final String? addressProofUrl;
  final String? nameError;
  final String? phoneError;
  final String? ageError;
  final String? guardianNameError;
  final String? guardianPhoneError;
  final String? guardianRelationError;
  final String? idProofError;
  final String? addressProofError;

  OccupantFieldState({
    this.name = '',
    this.phone = '',
    this.age = '',
    this.guardianName = '',
    this.guardianPhone = '',
    this.guardianRelation = '',
    this.idProof,
    this.addressProof,
    this.idProofUrl,
    this.addressProofUrl,
    this.nameError,
    this.phoneError,
    this.ageError,
    this.guardianNameError,
    this.guardianPhoneError,
    this.guardianRelationError,
    this.idProofError,
    this.addressProofError,
  });

  @override
  List<Object?> get props => [
    name,
    phone,
    age,
    guardianName,
    guardianPhone,
    guardianRelation,
    idProof,
    addressProof,
    idProofUrl,
    addressProofUrl,
    nameError,
    phoneError,
    ageError,
    guardianNameError,
    guardianPhoneError,
    guardianRelationError,
    idProofError,
    addressProofError,
  ];
}