import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/core/entity/occupant_entity.dart';
import 'package:packinn/features/app/pages/home/domain/repository/occupants_repository.dart';

class FetchOccupants extends UseCase<List<OccupantEntity>, String> {
  final OccupantsRepository repository;

  FetchOccupants(this.repository);

  @override
  Future<Either<Failure, List<OccupantEntity>>> call(String userId) async {
    return await repository.fetchOccupants(userId);
  }
}