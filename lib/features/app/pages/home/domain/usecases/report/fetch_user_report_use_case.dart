import 'package:dartz/dartz.dart';

import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/usecases/usecase.dart';
import '../../entity/report_entity.dart';
import '../../repository/report_repository.dart';

class FetchUserReportsUseCase implements UseCaseNoParams<List<ReportEntity>> {
  final ReportRepository repository;

  FetchUserReportsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReportEntity>>> call() async {
    return await repository.fetchReportsBySenderId();
  }
}