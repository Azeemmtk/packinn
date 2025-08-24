import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/entity/hostel_entity.dart';
import '../../../../domain/usecases/get_hostel_data.dart';
import '';
part 'hostel_event.dart';
part 'hostel_state.dart';

class HostelBloc extends Bloc<HostelEvent, HostelState> {
  final GetHostelData getHostelData;

  HostelBloc({required this.getHostelData})
      : super(HostelInitial()) {
    on<FetchHostelsData>((event, emit) async {
      emit(HostelLoading());
      final result = await getHostelData();
      result.fold(
            (failure) => emit(HostelError(failure.message)),
            (hostels) => emit(HostelLoaded(hostels)),
      );
    });
  }
}