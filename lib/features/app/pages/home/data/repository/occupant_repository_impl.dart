import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/home/data/datasource/occupant_remote_data_sourse.dart';
import 'package:packinn/core/entity/occupant_entity.dart';
import 'package:packinn/features/app/pages/home/domain/repository/occupants_repository.dart';

class OccupantRepositoryImpl extends OccupantsRepository {
  final OccupantRemoteDataSource remoteDataSource;

  OccupantRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> saveOccupant(OccupantEntity occupant) async {
    try {
      await remoteDataSource.saveOccupant(occupant);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OccupantEntity>>> fetchOccupants(String userId) async {
    try {
      final occupants = await remoteDataSource.fetchOccupants(userId);
      return Right(occupants);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOccupant(String occupantId) async{
    try{
      await remoteDataSource.deleteOccupant(occupantId);
      return Right(null);
    } on ServerException catch (e){
      return Left(ServerFailure(e.message));
    }
  }
}
