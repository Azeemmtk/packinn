import 'package:equatable/equatable.dart';
import 'package:packinn/core/entity/hostel_entity.dart';
import '../../../../../../core/entity/occupant_entity.dart';

class BookingEntity extends Equatable {
  final OccupantEntity occupant;
  final HostelEntity hostel;
  final Map<String, dynamic> room;

  const BookingEntity({
    required this.occupant,
    required this.hostel,
    required this.room,
  });

  @override
  List<Object?> get props => [occupant, hostel, room];
}