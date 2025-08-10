import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../home/domain/entity/hostel_entity.dart';
import '../../domain/repository/hostel_search_repository.dart';
import '../datasource/hostel_search_remote_data_source.dart';

class HostelSearchRepositoryImpl implements HostelSearchRepository {
  final HostelSearchRemoteDataSource remoteDataSource;

  HostelSearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<HostelEntity>>> searchHostels(
      String query) async {
    try {
      final hostels = await remoteDataSource.getHostelData();
      return hostels.fold(
        (failure) => Left(failure),
        (hostelList) => Right(
          hostelList
              .where((hostel) =>
                  hostel.name.toLowerCase().contains(query.toLowerCase()))
              .toList(),
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to search hostels: $e'));
    }
  }
}
