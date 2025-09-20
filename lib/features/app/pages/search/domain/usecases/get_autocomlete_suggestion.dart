import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../repository/hostel_search_repository.dart';

class GetAutocompleteSuggestions {
  final HostelSearchRepository repository;

  GetAutocompleteSuggestions(this.repository);

  Future<Either<Failure, List<String>>> call(String query) async {
    return await repository.getAutocompleteSuggestions(query);
  }
}