import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';

import '../../../../../../../core/usecases/usecase.dart';
import '../../entity/report_entity.dart';
import '../../repository/report_repository.dart';

class SubmitReportUseCase implements UseCase<void, ReportEntity> {
  final ReportRepository repository;

  SubmitReportUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ReportEntity params) async {
    return await repository.submitReport(params);
  }
}