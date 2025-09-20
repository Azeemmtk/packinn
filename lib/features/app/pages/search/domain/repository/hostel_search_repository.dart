import 'package:dartz/dartz.dart';
import '../../../../../../core/entity/hostel_entity.dart';
import '../../../../../../core/error/failures.dart';
import '../../presentation/provider/cubit/search_filter/search_filter_state.dart';

abstract class HostelSearchRepository {
  Future<Either<Failure, List<HostelEntity>>> searchHostels(String query, SearchFilterState filters);
  Future<Either<Failure, List<String>>> getAutocompleteSuggestions(String query);
}