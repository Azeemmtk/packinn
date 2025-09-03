import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';
import '../../domain/repository/owner_repository.dart';
import '../datasource/owner_remote_data_source.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerRemoteDataSource remoteDataSource;

  OwnerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<String, String>>> getOwnerDetails(String ownerId) async {
    try {
      final result = await remoteDataSource.getOwnerDetails(ownerId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}