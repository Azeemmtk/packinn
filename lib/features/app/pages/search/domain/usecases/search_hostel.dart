import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../../../../core/entity/hostel_entity.dart';
import '../../presentation/provider/cubit/search_filter/search_filter_state.dart';
import '../repository/hostel_search_repository.dart';

class SearchHostels implements UseCase<List<HostelEntity>, SearchHostelParams> {
  final HostelSearchRepository repository;

  SearchHostels(this.repository);

  @override
  Future<Either<Failure, List<HostelEntity>>> call(SearchHostelParams params) async {
    return await repository.searchHostels(params.query, params.filters);
  }
}

class SearchHostelParams {
  final String query;
  final SearchFilterState filters;

  SearchHostelParams(this.query, this.filters);
}