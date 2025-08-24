import 'package:equatable/equatable.dart';

class OccupantEntity extends Equatable {
  final String? id;
  final String name;
  final String phone;
  final int age;
  final GuardianEntity? guardian;
  final String? idProofUrl;
  final String? addressProofUrl;
  final String userId;
  final String? hostelId;
  final String? roomId;
  final bool rentPaid;

  const OccupantEntity({
    this.id,
    required this.name,
    required this.phone,
    required this.age,
    this.guardian,
    this.idProofUrl,
    this.addressProofUrl,
    required this.userId,
    this.hostelId,
    this.roomId,
    this.rentPaid= false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    age,
    guardian,
    idProofUrl,
    addressProofUrl,
    userId,
    hostelId,
    roomId,
    rentPaid
  ];
}

class GuardianEntity extends Equatable {
  final String name;
  final String phone;
  final String relation;

  const GuardianEntity({
    required this.name,
    required this.phone,
    required this.relation,
  });

  @override
  List<Object?> get props => [name, phone, relation];
}