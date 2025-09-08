import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packinn/core/services/current_user.dart';

import '../../domain/entity/report_entity.dart';

abstract class ReportDataSource {
  Future<void> submitReport(ReportEntity report);
  Future<List<ReportEntity>> fetchReportsBySenderId();
}

class ReportDataSourceImpl implements ReportDataSource {
  final FirebaseFirestore firestore;

  ReportDataSourceImpl({required this.firestore});

  @override
  Future<void> submitReport(ReportEntity report) async {
    await firestore.collection('reports').add(report.toMap());
  }

  @override
  Future<List<ReportEntity>> fetchReportsBySenderId() async {
    final snapshot = await firestore.collection('reports')
        .where('senderId', isEqualTo: CurrentUser().uId)
        .get();
    return snapshot.docs
        .map((doc) => ReportEntity.fromMap(doc.data(), doc.id))
        .toList();
  }
}