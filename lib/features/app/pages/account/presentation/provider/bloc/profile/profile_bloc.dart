import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:packinn/core/error/failures.dart';

import '../../../../../../../auth/data/model/user_model.dart';
import '../../../../domain/usecases/get_user_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUseCase getUserUseCase;

  ProfileBloc({required this.getUserUseCase}) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await getUserUseCase(event.uid);
    result.fold(
          (failure) => emit(ProfileError(message: failure.message)),
          (user) => emit(ProfileLoaded(user: user)),
    );
  }
}