import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../../../../core/services/geolocator_service.dart';
import 'location_state.dart';


class LocationCubit extends Cubit<LocationState> {
  final GeolocationService _geolocationService;

  LocationCubit(this._geolocationService) : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    emit(LocationLoading());
    try {
      final locationData = await _geolocationService.getCurrentLocation();
      if (locationData != null) {
        final position = locationData['position'] as Position;
        emit(LocationLoaded(
          locationData['placeName'],
          position.latitude,
          position.longitude,
        ));
      } else {
        emit(LocationError('Failed to get location'));
      }
    } catch (e) {
      emit(LocationError('Error fetching location: $e'));
    }
  }
}