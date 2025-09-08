import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import '../../../../domain/entity/report_entity.dart';
import '../../../../domain/usecases/report/fetch_user_report_use_case.dart';
import '../../../../domain/usecases/report/submit_report_usecase.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final SubmitReportUseCase submitReportUseCase;
  final FetchUserReportsUseCase fetchUserReportsUseCase;

  ReportBloc({
    required this.submitReportUseCase,
    required this.fetchUserReportsUseCase,
  }) : super(ReportInitial()) {
    on<SubmitReportEvent>(_onSubmitReport);
    on<FetchUserReportsEvent>(_onFetchUserReports);
  }

  Future<void> _onSubmitReport(SubmitReportEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    final result = await submitReportUseCase(event.report);
    emit(result.fold(
          (failure) => ReportError(message: failure.message),
          (_) => ReportSubmitted(),
    ));
  }

  Future<void> _onFetchUserReports(FetchUserReportsEvent event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    final result = await fetchUserReportsUseCase();
    emit(result.fold(
          (failure) => ReportError(message: failure.message),
          (reports) => ReportLoaded(reports: reports),
    ));
  }
}