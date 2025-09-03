import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../../domain/entity/map_hostel.dart';

abstract class MapSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class MapSearchInitial extends MapSearchState {}

class MapSearchLoading extends MapSearchState {}

class MapSearchLoaded extends MapSearchState {
  final LatLng selectedPoint;
  final List<MapHostel> hostels;

  MapSearchLoaded(this.selectedPoint, this.hostels);

  @override
  List<Object> get props => [selectedPoint, hostels];
}

class MapSearchError extends MapSearchState {
  final String message;

  MapSearchError(this.message);

  @override
  List<Object> get props => [message];
}