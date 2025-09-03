import 'package:dio/dio.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../domain/entity/map_hostel.dart';

class OverpassRemoteDataSource {
  final Dio dio;
  static const int _maxRetries = 3;
  static const int _retryDelayMs = 1000; // 1 second delay between retries

  OverpassRemoteDataSource(this.dio);

  Future<List<MapHostel>> searchHostelsNearby(double lat, double lng, double radius) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final query = '[out:json];node(around:$radius,$lat,$lng)["tourism"="hostel"];out;';
        final response = await dio.post(
          'https://overpass-api.de/api/interpreter',
          data: query,
          options: Options(
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            receiveTimeout: Duration(seconds: 5), // Set timeout to avoid long waits
          ),
        );

        if (response.statusCode == 200) {
          final elements = response.data['elements'] as List<dynamic>? ?? [];
          return elements.map((e) {
            final tags = e['tags'] as Map<String, dynamic>? ?? {};
            return MapHostel(
              name: tags['name'] ?? 'Unnamed Hostel',
              location: tags['addr:city'] ?? tags['addr:street'] ?? 'Unknown',
              latitude: e['lat'] as double,
              longitude: e['lon'] as double,
            );
          }).toList();
        } else if (response.statusCode == 504) {
          attempt++;
          if (attempt >= _maxRetries) {
            throw ServerException('Overpass API timed out after $_maxRetries attempts');
          }
          await Future.delayed(Duration(milliseconds: _retryDelayMs));
          continue;
        } else {
          throw ServerException('Failed to query Overpass API: ${response.statusCode}');
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 504) {
          attempt++;
          if (attempt >= _maxRetries) {
            throw ServerException('Overpass API timed out after $_maxRetries attempts');
          }
          await Future.delayed(Duration(milliseconds: _retryDelayMs));
          continue;
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          throw NetworkException('Network timeout while querying Overpass API');
        }
        throw ServerException('Overpass API error: ${e.message}');
      } catch (e) {
        throw ServerException('Unexpected error: $e');
      }
    }
    throw ServerException('Failed to query Overpass API after retries');
  }
}