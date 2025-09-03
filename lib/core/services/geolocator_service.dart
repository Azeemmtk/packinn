import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GeolocationService {
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Map<String, dynamic>?> getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placeName = await _getPlaceName(position);

      return {
        'position': position,
        'placeName': placeName,
      };
    } catch (e) {
      return null;
    }
  }

  Future<String> _getPlaceName(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return [
          placemark.locality,
          placemark.administrativeArea,
          placemark.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      }
      return 'Unknown location';
    } catch (e) {
      return 'Unknown location';
    }
  }

  Future<String> getPlaceNameFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return [
          placemark.locality,
          placemark.administrativeArea,
          placemark.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      }
      return 'Unknown location';
    } catch (e) {
      return 'Unknown location';
    }
  }
}