import 'package:equatable/equatable.dart';
import 'package:packinn/core/utils/enums.dart';

class HostelEntity extends Equatable {
  final String id;
  final String name;
  final String placeName;
  final double latitude;
  final double longitude;
  final String contactNumber;
  final String description;
  final List<String> facilities;
  final List<String>? occupantsId;
  final List<Map<String, dynamic>> rooms;
  final String ownerId;
  final String ownerName;
  final String? mainImageUrl;
  final String? mainImagePublicId;
  final List<String> smallImageUrls;
  final List<String> smallImagePublicIds;
  final DateTime createdAt;
  final Status status;

  const HostelEntity({
    required this.id,
    required this.name,
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.contactNumber,
    required this.description,
    required this.facilities,
    this.occupantsId,
    required this.rooms,
    required this.ownerId,
    required this.ownerName,
    this.mainImageUrl,
    this.mainImagePublicId,
    required this.smallImageUrls,
    required this.smallImagePublicIds,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    placeName,
    latitude,
    longitude,
    contactNumber,
    description,
    facilities,
    rooms,
    ownerId,
    ownerName,
    mainImageUrl,
    mainImagePublicId,
    smallImageUrls,
    smallImagePublicIds,
    createdAt,
    status,
  ];
}