part of 'add_occupant_bloc.dart';

abstract class AddOccupantEvent extends Equatable {
  const AddOccupantEvent();

  @override
  List<Object?> get props => [];
}

class FetchOccupantsEvent extends AddOccupantEvent {
  final String userId;

  const FetchOccupantsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateOccupantEvent extends AddOccupantEvent {
  final String? name;
  final String? phone;
  final int? age;
  final String? guardianName;
  final String? guardianPhone;
  final String? guardianRelation;
  final File? idProof;
  final File? addressProof;
  final String? idProofUrl; // Added for existing image URL
  final String? addressProofUrl; // Added for existing image URL

  UpdateOccupantEvent({
    this.name,
    this.phone,
    this.age,
    this.guardianName,
    this.guardianPhone,
    this.guardianRelation,
    this.idProof,
    this.addressProof,
    this.idProofUrl,
    this.addressProofUrl,
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
  ];
}

class SaveOccupantEvent extends AddOccupantEvent {
  final Map<String, dynamic> room;
  final String? occupantId;

  SaveOccupantEvent(this.room, {this.occupantId});

  @override
  List<Object?> get props => [room, occupantId];
}

class SelectOccupantEvent extends AddOccupantEvent {
  final OccupantEntity occupant;
  final Map<String, dynamic> room;

  SelectOccupantEvent(this.occupant, this.room);

  @override
  List<Object?> get props => [occupant, room];
}

class DeleteOccupantEvent extends AddOccupantEvent {
  final String occupantId;

  DeleteOccupantEvent(this.occupantId);

  @override
  List<Object?> get props => [occupantId];
}

class ToggleFormEvent extends AddOccupantEvent {
  final bool showForm;

  ToggleFormEvent(this.showForm);

  @override
  List<Object?> get props => [showForm];
}