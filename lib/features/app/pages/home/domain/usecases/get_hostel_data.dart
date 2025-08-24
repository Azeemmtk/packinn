import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../../../../core/entity/hostel_entity.dart';
import '../repository/hostel_repository.dart';

class GetHostelData extends UseCaseNoParams<List<HostelEntity>> {
  final HostelRepository repository;

  GetHostelData(this.repository);

  @override
  Future<Either<Failure, List<HostelEntity>>> call() async {
    return await repository.getHostelData();
  }
}
