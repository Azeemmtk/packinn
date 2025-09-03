import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repository/owner_repository.dart';

class GetOwnerDetailsUseCase extends UseCase<Map<String, String>, String> {
  final OwnerRepository repository;

  GetOwnerDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, String>>> call(String ownerId) {
    return repository.getOwnerDetails(ownerId);
  }
}