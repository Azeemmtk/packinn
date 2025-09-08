import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import '../entity/reposrt_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, void>> submitReport(ReportEntity report);
  Future<Either<Failure, List<ReportEntity>>> fetchReportsBySenderId(String senderId);
}
