import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';

import '../entity/map_hostel.dart';

abstract class HostelMapSearchRepository {
  Future<Either<Failure, List<MapHostel>>> searchHostelsNearby(double lat, double lng, double radius);
}