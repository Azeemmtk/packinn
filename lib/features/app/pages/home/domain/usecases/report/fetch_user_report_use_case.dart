import 'package:dartz/dartz.dart';

import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/usecases/usecase.dart';
import '../../entity/reposrt_entity.dart';
import '../../repository/report_repository.dart';

class FetchUserReportsUseCase implements UseCase<List<ReportEntity>, String> {
  final ReportRepository repository;

  FetchUserReportsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReportEntity>>> call(String senderId) async {
    return await repository.fetchReportsBySenderId(senderId);
  }
}