import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/home/domain/usecases/get_user_details.dart';
import '../../../../../../../../core/model/user_model.dart';
part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final GetUserDetailsUseCase userDetailsUseCase;

  UserDetailsBloc({required this.userDetailsUseCase}) : super(UserDetailsInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
  }

  Future<void> _onFetchUserDetails(FetchUserDetails event, Emitter<UserDetailsState> emit) async {
    emit(UserDetailsLoading());
    final result = await userDetailsUseCase(event.uid);
    emit(result.fold(
          (failure) => UserDetailsError(message: _mapFailureToMessage(failure)),
          (user) => UserDetailsLoaded(user: user),
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      default:
        return 'Unexpected error occurred';
    }
  }
}