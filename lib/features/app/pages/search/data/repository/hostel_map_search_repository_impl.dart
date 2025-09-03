import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/search/data/datasource/overpass_remote_data_source.dart';
import 'package:packinn/features/app/pages/search/domain/repository/hostel_map_search_repository.dart';

import '../../../../../../core/error/exceptions.dart';
import '../../domain/entity/map_hostel.dart';

class HostelMapSearchRepositoryImpl implements HostelMapSearchRepository {
  final OverpassRemoteDataSource dataSource;

  HostelMapSearchRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<MapHostel>>> searchHostelsNearby(double lat, double lng, double radius) async {
    try {
      final result = await dataSource.searchHostelsNearby(lat, lng, radius);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected failure: $e'));
    }
  }
}