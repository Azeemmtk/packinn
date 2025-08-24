import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../../../core/services/cloudinary_services.dart';
import '../../../../../../../../core/entity/occupant_entity.dart';
import '../../../../domain/usecases/save_occupant.dart';
import '../../../../domain/usecases/fetch_occupants.dart';
import '../../../../domain/usecases/delete_occupant.dart';
import 'package:packinn/core/services/current_user.dart';

part 'add_occupant_event.dart';
part 'add_occupant_state.dart';

class AddOccupantBloc extends Bloc<AddOccupantEvent, AddOccupantState> {
  final SaveOccupant saveOccupant;
  final FetchOccupants fetchOccupants;
  final DeleteOccupant deleteOccupant;
  final CloudinaryService cloudinaryService;

  AddOccupantBloc({
    required this.saveOccupant,
    required this.fetchOccupants,
    required this.deleteOccupant,
    required this.cloudinaryService,
  }) : super(AddOccupantInitial()) {
    on<FetchOccupantsEvent>(_onFetchOccupants);
    on<UpdateOccupantEvent>(_onUpdateOccupant);
    on<SaveOccupantEvent>(_onSaveOccupant);
    on<DeleteOccupantEvent>(_onDeleteOccupant);
    on<SelectOccupantEvent>(_onSelectOccupant);
    on<ToggleFormEvent>(_onToggleForm);
  }

  Future<void> _onFetchOccupants(
      FetchOccupantsEvent event, Emitter<AddOccupantState> emit) async {
    emit(AddOccupantLoading());
    try {
      final result = await fetchOccupants(event.userId);
      result.fold(
            (failure) => emit(AddOccupantError(failure.message)),
            (occupants) => emit(AddOccupantLoaded(occupants: occupants, showForm: occupants.isEmpty)),
      );
    } catch (e) {
      emit(AddOccupantError('Failed to fetch occupants: $e'));
    }
  }

  void _onUpdateOccupant(
      UpdateOccupantEvent event, Emitter<AddOccupantState> emit) {
    final currentState = state is AddOccupantLoaded
        ? state as AddOccupantLoaded
        : AddOccupantLoaded();
    emit(AddOccupantLoaded(
      name: event.name ?? currentState.name,
      phone: event.phone ?? currentState.phone,
      age: event.age ?? currentState.age,
      guardianName: event.guardianName ?? currentState.guardianName,
      guardianPhone: event.guardianPhone ?? currentState.guardianPhone,
      guardianRelation: event.guardianRelation ?? currentState.guardianRelation,
      idProof: event.idProof ?? currentState.idProof,
      addressProof: event.addressProof ?? currentState.addressProof,
      idProofUrl: event.idProofUrl ?? currentState.idProofUrl,
      addressProofUrl: event.addressProofUrl ?? currentState.addressProofUrl,
      occupants: currentState.occupants,
      showForm: currentState.showForm,
    ));
  }

  Future<void> _onSaveOccupant(
      SaveOccupantEvent event, Emitter<AddOccupantState> emit) async {
    if (state is AddOccupantLoaded) {
      final currentState = state as AddOccupantLoaded;
      emit(AddOccupantLoading());

      try {
        // Only upload images that have been updated
        final List<File?> imagesToUpload = [];
        if (currentState.idProof != null) imagesToUpload.add(currentState.idProof);
        if (currentState.addressProof != null) imagesToUpload.add(currentState.addressProof);

        final imageUrls = await cloudinaryService.uploadImage(imagesToUpload);

        // Preserve existing URLs if images aren't uploaded
        final String? newIdProofUrl = currentState.idProof != null
            ? imageUrls.isNotEmpty ? imageUrls[0]['secureUrl'] : null
            : currentState.idProofUrl;
        final String? newAddressProofUrl = currentState.addressProof != null
            ? imageUrls.length > 1 ? imageUrls[1]['secureUrl'] : imageUrls.isNotEmpty ? imageUrls[0]['secureUrl'] : null
            : currentState.addressProofUrl;

        final occupant = OccupantEntity(
          id: event.occupantId,
          name: currentState.name,
          phone: currentState.phone,
          age: currentState.age!,
          guardian: currentState.age! < 18
              ? GuardianEntity(
            name: currentState.guardianName,
            phone: currentState.guardianPhone,
            relation: currentState.guardianRelation,
          )
              : null,
          idProofUrl: newIdProofUrl,
          addressProofUrl: newAddressProofUrl,
          userId: CurrentUser().uId!,
          hostelId: null,
          roomId: null,
        );

        final result = await saveOccupant(occupant);
        result.fold(
              (failure) => emit(AddOccupantError(failure.message)),
              (_) => emit(AddOccupantSuccess(occupant, event.room)),
        );
      } catch (e) {
        emit(AddOccupantError('Failed to save occupant: $e'));
      }
    }
  }

  Future<void> _onDeleteOccupant(
      DeleteOccupantEvent event, Emitter<AddOccupantState> emit) async {
    emit(AddOccupantLoading());
    try {
      final result = await deleteOccupant(event.occupantId);
      await result.fold(
            (failure) async => emit(AddOccupantError(failure.message)),
            (_) async {
          // Fetch updated occupants list directly
          final fetchResult = await fetchOccupants(CurrentUser().uId!);
          await fetchResult.fold(
                (failure) async => emit(AddOccupantError(failure.message)),
                (occupants) async => emit(AddOccupantLoaded(
              name: '',
              phone: '',
              age: null,
              guardianName: '',
              guardianPhone: '',
              guardianRelation: '',
              idProof: null,
              addressProof: null,
              idProofUrl: null,
              addressProofUrl: null,
              occupants: occupants,
              showForm: occupants.isEmpty,
            )),
          );
        },
      );
    } catch (e) {
      emit(AddOccupantError('Failed to delete occupant: $e'));
    }
  }

  void _onSelectOccupant(
      SelectOccupantEvent event, Emitter<AddOccupantState> emit) {
    emit(AddOccupantSuccess(event.occupant, event.room));
  }

  void _onToggleForm(ToggleFormEvent event, Emitter<AddOccupantState> emit) {
    final currentState = state is AddOccupantLoaded ? state as AddOccupantLoaded : AddOccupantLoaded();
    emit(AddOccupantLoaded(
      name: currentState.name,
      phone: currentState.phone,
      age: currentState.age,
      guardianName: currentState.guardianName,
      guardianPhone: currentState.guardianPhone,
      guardianRelation: currentState.guardianRelation,
      idProof: currentState.idProof,
      addressProof: currentState.addressProof,
      idProofUrl: currentState.idProofUrl,
      addressProofUrl: currentState.addressProofUrl,
      occupants: currentState.occupants,
      showForm: event.showForm,
    ));
  }
}