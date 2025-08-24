part of 'add_occupant_bloc.dart';

abstract class AddOccupantState extends Equatable {
  const AddOccupantState();

  @override
  List<Object?> get props => [];
}

class AddOccupantInitial extends AddOccupantState {}

class AddOccupantLoading extends AddOccupantState {}

class AddOccupantLoaded extends AddOccupantState {
  final String name;
  final String phone;
  final int? age;
  final String guardianName;
  final String guardianPhone;
  final String guardianRelation;
  final File? idProof;
  final File? addressProof;
  final String? idProofUrl; // Added for existing image URL
  final String? addressProofUrl; // Added for existing image URL
  final List<OccupantEntity> occupants;
  final bool showForm;

  AddOccupantLoaded({
    this.name = '',
    this.phone = '',
    this.age,
    this.guardianName = '',
    this.guardianPhone = '',
    this.guardianRelation = '',
    this.idProof,
    this.addressProof,
    this.idProofUrl,
    this.addressProofUrl,
    this.occupants = const [],
    this.showForm = true,
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
    occupants,
    showForm,
  ];
}

class AddOccupantSuccess extends AddOccupantState {
  final OccupantEntity occupant;
  final Map<String, dynamic> room;

  AddOccupantSuccess(this.occupant, this.room);

  @override
  List<Object?> get props => [occupant, room];
}

class AddOccupantError extends AddOccupantState {
  final String message;

  AddOccupantError(this.message);

  @override
  List<Object?> get props => [message];
}