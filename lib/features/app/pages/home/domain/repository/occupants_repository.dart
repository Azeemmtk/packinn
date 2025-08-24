import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/entity/occupant_entity.dart';

abstract class OccupantsRepository{
  Future<Either<Failure, void>> saveOccupant(OccupantEntity occupant);
  Future<Either<Failure, List<OccupantEntity>>> fetchOccupants(String userId);
  Future<Either<Failure, void>> deleteOccupant(String occupantId);
}