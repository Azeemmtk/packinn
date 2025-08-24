import 'package:bloc/bloc.dart';
import '../../../../../../../../core/usecases/usecase.dart';
import '../../../../domain/usecases/get_my_bookings.dart';
import 'my_booking_event.dart';
import 'my_booking_state.dart';

class MyBookingsBloc extends Bloc<MyBookingsEvent, MyBookingsState> {
  final GetMyBookingsUseCase getMyBookingsUseCase;

  MyBookingsBloc({required this.getMyBookingsUseCase}) : super(MyBookingsInitial()) {
    on<LoadMyBookings>(_onLoadMyBookings);
  }

  Future<void> _onLoadMyBookings(LoadMyBookings event, Emitter<MyBookingsState> emit) async {
    emit(MyBookingsLoading());
    final result = await getMyBookingsUseCase(const NoParams());
    result.fold(
          (failure) => emit(MyBookingsError(failure.message)),
          (bookings) => emit(MyBookingsLoaded(bookings)),
    );
  }
}