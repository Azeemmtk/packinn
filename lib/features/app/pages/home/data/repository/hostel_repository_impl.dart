import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/entity/hostel_entity.dart';
import '../../domain/repository/hostel_repository.dart';
import '../datasource/hostel_remote_data_source.dart';

class HostelRepositoryImpl implements HostelRepository {
  final HostelRemoteDataSource hostelRemoteDataSource;

  HostelRepositoryImpl( this.hostelRemoteDataSource);

  @override
  Future<Either<Failure, List<HostelEntity>>> getHostelData() async {
    return await hostelRemoteDataSource.getHostelData();
  }
}
