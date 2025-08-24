import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/home/domain/repository/occupants_repository.dart';

class DeleteOccupant extends UseCase<void, String> {
  final OccupantsRepository repository;
  DeleteOccupant(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteOccupant(params);
  }
}
