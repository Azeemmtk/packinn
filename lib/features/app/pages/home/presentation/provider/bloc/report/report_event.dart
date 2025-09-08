part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class SubmitReportEvent extends ReportEvent {
  final ReportEntity report;

  const SubmitReportEvent({required this.report});

  @override
  List<Object> get props => [report];
}

class FetchUserReportsEvent extends ReportEvent {
  final String senderId;

  const FetchUserReportsEvent({required this.senderId});

  @override
  List<Object> get props => [senderId];
}