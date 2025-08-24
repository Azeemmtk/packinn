import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/core/entity/occupant_entity.dart';
import 'package:packinn/features/app/pages/home/domain/repository/occupants_repository.dart';

class SaveOccupant extends UseCase<void, OccupantEntity> {
  final OccupantsRepository repository;
  SaveOccupant(this.repository);

  @override
  Future<Either<Failure, void>> call(OccupantEntity params) async {
    return await repository.saveOccupant(params);
  }
}
