import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../home/domain/entity/hostel_entity.dart';
import '../repository/hostel_search_repository.dart';

class SearchHostels implements UseCase<List<HostelEntity>, String> {
  final HostelSearchRepository repository;

  SearchHostels(this.repository);

  @override
  Future<Either<Failure, List<HostelEntity>>> call(String query) async {
    return await repository.searchHostels(query);
  }
}