import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class MapSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TapOnMap extends MapSearchEvent {
  final LatLng point;

  TapOnMap(this.point);

  @override
  List<Object> get props => [point];
}