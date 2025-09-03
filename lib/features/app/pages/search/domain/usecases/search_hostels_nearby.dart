import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/search/domain/repository/hostel_map_search_repository.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../entity/map_hostel.dart';

class SearchHostelsNearby implements UseCase<List<MapHostel>, SearchHostelsNearbyParams> {
  final HostelMapSearchRepository repository;

  SearchHostelsNearby(this.repository);

  @override
  Future<Either<Failure, List<MapHostel>>> call(SearchHostelsNearbyParams params) {
    return repository.searchHostelsNearby(params.lat, params.lng, params.radius);
  }
}

class SearchHostelsNearbyParams {
  final double lat;
  final double lng;
  final double radius;

  SearchHostelsNearbyParams({required this.lat, required this.lng, required this.radius});
}