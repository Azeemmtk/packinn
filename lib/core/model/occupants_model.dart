import '../entity/occupant_entity.dart';

class OccupantModel {
  String? id;
  final String name;
  final String phone;
  final int age;
  final Map<String, dynamic>? guardian;
  final String? idProofUrl;
  final String? addressProofUrl;
  final String userId;
  final String? hostelId;
  final String? roomId;
  final bool rentPaid;

  OccupantModel({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'age': age,
      'guardian': guardian,
      'idProofUrl': idProofUrl,
      'addressProofUrl': addressProofUrl,
      'userId': userId,
      'hostelId': hostelId,
      'roomId': roomId,
      'rentPaid': rentPaid,
    };
  }

  OccupantEntity toEntity() {
    return OccupantEntity(
      id: id,
      name: name,
      phone: phone,
      age: age,
      guardian: guardian != null
          ? GuardianEntity(
        name: guardian!['name'],
        phone: guardian!['phone'],
        relation: guardian!['relation'],
      )
          : null,
      idProofUrl: idProofUrl,
      addressProofUrl: addressProofUrl,
      userId: userId,
      hostelId: hostelId,
      roomId: roomId,
      rentPaid: rentPaid,
    );
  }

  factory OccupantModel.fromEntity(OccupantEntity occupant) {
    return OccupantModel(
      id: occupant.id,
      name: occupant.name,
      phone: occupant.phone,
      age: occupant.age,
      guardian: occupant.guardian != null
          ? {
        'name': occupant.guardian!.name,
        'phone': occupant.guardian!.phone,
        'relation': occupant.guardian!.relation,
      }
          : null,
      idProofUrl: occupant.idProofUrl,
      addressProofUrl: occupant.addressProofUrl,
      userId: occupant.userId,
      hostelId: occupant.hostelId,
      roomId: occupant.roomId,
      rentPaid: occupant.rentPaid
    );
  }

  factory OccupantModel.fromJson(Map<String, dynamic> json) {
    return OccupantModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      age: json['age'],
      guardian: json['guardian'],
      idProofUrl: json['idProofUrl'],
      addressProofUrl: json['addressProofUrl'],
      userId: json['userId'],
      hostelId: json['hostelId'],
      roomId: json['roomId'],
      rentPaid: json['rentPaid']
    );
  }
}