import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:packinn/core/error/failures.dart';

import '../../../../../../../auth/data/model/user_model.dart';
import '../../../../domain/usecases/update_user_use_case.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateUserUseCase updateUserUseCase;

  EditProfileBloc({required this.updateUserUseCase}) : super(EditProfileInitial()) {
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileSubmitting());
    final result = await updateUserUseCase(event.user);
    result.fold(
          (failure) => emit(EditProfileError(message: failure.message)),
          (_) => emit(EditProfileSuccess()),
    );
  }
}