import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/features/app/pages/search/domain/usecases/search_hostels_nearby.dart';
import 'map_search_event.dart';
import 'map_search_state.dart';

class MapSearchBloc extends Bloc<MapSearchEvent, MapSearchState> {
  final SearchHostelsNearby searchHostelsNearby;

  MapSearchBloc(this.searchHostelsNearby) : super(MapSearchInitial()) {
    on<TapOnMap>(_onTapOnMap);
  }

  Future<void> _onTapOnMap(TapOnMap event, Emitter<MapSearchState> emit) async {
    emit(MapSearchLoading());
    try {
      final result = await searchHostelsNearby(SearchHostelsNearbyParams(
        lat: event.point.latitude,
        lng: event.point.longitude,
        radius: 5000.0, // 5km
      ));
      emit(result.fold(
            (failure) => MapSearchError(failure.message),
            (hostels) => MapSearchLoaded(event.point, hostels),
      ));
    } catch (e) {
      emit(MapSearchError('Unexpected error: $e'));
    }
  }
}