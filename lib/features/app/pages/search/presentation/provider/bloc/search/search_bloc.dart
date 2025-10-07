import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../domain/usecases/get_autocomlete_suggestion.dart';
import '../../../../domain/usecases/search_hostel.dart';
import '../../cubit/search_filter/search_filter_state.dart';
import '../../cubit/loacation/location_cubit.dart';
import '../../cubit/loacation/location_state.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../../../../../../../core/entity/hostel_entity.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchHostels searchHostels;
  final GetAutocompleteSuggestions getAutocompleteSuggestions;
  final Map<String, List<HostelEntity>> _cache = {};

  SearchBloc({
    required this.searchHostels,
    required this.getAutocompleteSuggestions,
  }) : super(SearchInitial()) {
    on<SearchHostelsEvent>(_onSearchHostels);
    on<GetAutocompleteSuggestionsEvent>(_onGetAutocompleteSuggestions);
  }

  String _generateCacheKey(String query, SearchFilterState filters) {
    return '${query}_${filters.facilities.join(',')}_${filters.roomTypes.join(',')}_${filters.priceRange.start}_${filters.priceRange.end}_${filters.distanceRange.start}_${filters.distanceRange.end}';
  }

  Future<void> _onSearchHostels(
      SearchHostelsEvent event, Emitter<SearchState> emit) async {
    final cacheKey = _generateCacheKey(event.query, event.filters);
    if (_cache.containsKey(cacheKey)) {
      emit(SearchLoaded(_cache[cacheKey]!));
      return;
    }

    emit(SearchLoading());
    try {
      final result = await searchHostels(SearchHostelParams(event.query, event.filters));
      result.fold(
            (failure) => emit(SearchError(failure.message)),
            (hostels) async {
          List<HostelEntity> filteredHostels = hostels;

          // Get current location from LocationCubit using the context from the event
          Position? userPosition;
          if (event.filters.context != null) {
            final locationState = BlocProvider.of<LocationCubit>(event.filters.context!).state;
            if (locationState is LocationLoaded) {
              userPosition = Position(
                latitude: locationState.latitude,
                longitude: locationState.longitude,
                timestamp: DateTime.now(),
                accuracy: 0.0,
                altitude: 0.0,
                heading: 0.0,
                speed: 0.0,
                speedAccuracy: 0.0,
                altitudeAccuracy: 0.0,
                headingAccuracy: 0.0,
              );
            }
          }

          filteredHostels = hostels.where((hostel) {
            // Check hostel name, place name, facilities, and room additionalFacility
            bool matchesQuery = event.query.isEmpty ||
                hostel.name.toLowerCase().contains(event.query.toLowerCase()) ||
                hostel.placeName.toLowerCase().contains(event.query.toLowerCase()) ||
                hostel.facilities.any((facility) =>
                    facility.toLowerCase().contains(event.query.toLowerCase())) ||
                hostel.rooms.any((room) =>
                    (room['additionalFacility'] ?? '')
                        .toLowerCase()
                        .contains(event.query.toLowerCase()));

            // Facility filter: Check both hostel facilities and room additionalFacility
            bool matchesFacilities = event.filters.facilities.isEmpty ||
                event.filters.facilities.every((facility) =>
                hostel.facilities.contains(facility) ||
                    hostel.rooms.any((room) =>
                        (room['additionalFacility'] ?? '')
                            .toLowerCase()
                            .contains(facility.toLowerCase())));

            // Room type filter
            bool matchesRoomTypes = event.filters.roomTypes.isEmpty ||
                hostel.rooms.any((room) =>
                    event.filters.roomTypes.contains(room['type']));

            // Price filter
            bool matchesPrice = hostel.rooms.isEmpty ||
                hostel.rooms.any((room) =>
                room['rate'] != null &&
                    room['rate'] >= event.filters.priceRange.start &&
                    room['rate'] <= event.filters.priceRange.end);

            // Distance filter
            bool matchesDistance = true;
            if (userPosition != null) {
              final distance = Geolocator.distanceBetween(
                userPosition.latitude,
                userPosition.longitude,
                hostel.latitude,
                hostel.longitude,
              ) / 1000; // Convert meters to kilometers
              matchesDistance = distance >= event.filters.distanceRange.start &&
                  distance <= event.filters.distanceRange.end;
            }

            return matchesQuery &&
                matchesFacilities &&
                matchesRoomTypes &&
                matchesPrice &&
                matchesDistance;
          }).toList();

          _cache[cacheKey] = filteredHostels;
          emit(SearchLoaded(filteredHostels));
        },
      );
    } catch (e) {
      emit(SearchError('Unexpected error during search: $e'));
    }
  }

  Future<void> _onGetAutocompleteSuggestions(
      GetAutocompleteSuggestionsEvent event, Emitter<SearchState> emit) async {
    try {
      final result = await getAutocompleteSuggestions(event.query);
      result.fold(
            (failure) => emit(SearchError(failure.message)),
            (suggestions) => emit(AutocompleteSuggestionsLoaded(suggestions)),
      );
    } catch (e) {
      emit(SearchError('Unexpected error during autocomplete: $e'));
    }
  }
}