abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final String placeName;
  final double latitude;
  final double longitude;

  LocationLoaded(this.placeName, this.latitude, this.longitude);
}

class LocationError extends LocationState {
  final String error;

  LocationError(this.error);
}