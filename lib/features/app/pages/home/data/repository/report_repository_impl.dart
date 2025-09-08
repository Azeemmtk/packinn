import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';

import '../../../../../../core/services/cloudinary_services.dart';
import '../../domain/entity/report_entity.dart';
import '../../domain/repository/report_repository.dart';
import '../datasource/report_data_source.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportDataSource dataSource;
  final CloudinaryService cloudinaryService;

  ReportRepositoryImpl({
    required this.dataSource,
    required this.cloudinaryService,
  });

  @override
  Future<Either<Failure, void>> submitReport(ReportEntity report) async {
    try {
      String? imageUrl;
      if (report.imageUrl != null && File(report.imageUrl!).existsSync()) {
        final uploadResult = await cloudinaryService.uploadImage([File(report.imageUrl!)]);
        imageUrl = uploadResult.isNotEmpty ? uploadResult.first['secureUrl'] : null;
      }
      final updatedReport = ReportEntity(
        id: report.id,
        message: report.message,
        imageUrl: imageUrl,
        senderId: report.senderId,
        hostelId: report.hostelId,
        ownerId: report.ownerId,
        createdAt: report.createdAt,
        status: report.status,
        adminAction: report.adminAction,
      );
      await dataSource.submitReport(updatedReport);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to submit report: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> fetchReportsBySenderId() async {
    try {
      final reports = await dataSource.fetchReportsBySenderId();
      return Right(reports);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch user reports: $e'));
    }
  }
}