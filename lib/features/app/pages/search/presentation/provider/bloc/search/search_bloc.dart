import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_autocomlete_suggestion.dart';
import '../../../../domain/usecases/search_hostel.dart';
import '../../cubit/search_filter/search_filter_state.dart';
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
    return '${query}_${filters.facilities.join(',')}_${filters.roomTypes.join(',')}_${filters.priceRange.start}_${filters.priceRange.end}';
  }

  Future<void> _onSearchHostels(
      SearchHostelsEvent event, Emitter<SearchState> emit) async {
    final cacheKey = _generateCacheKey(event.query, event.filters);
    if (_cache.containsKey(cacheKey)) {
      emit(SearchLoaded(_cache[cacheKey]!));
      return;
    }

    if (event.query.isEmpty &&
        event.filters.facilities.isEmpty &&
        event.filters.roomTypes.isEmpty &&
        event.filters.priceRange.start == 1000 &&
        event.filters.priceRange.end == 10000) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final result =
      await searchHostels(SearchHostelParams(event.query, event.filters));
      result.fold(
            (failure) => emit(SearchError(failure.message)),
            (hostels) {
          final filteredHostels = hostels.where((hostel) {
            bool matchesQuery = event.query.isEmpty ||
                hostel.name.toLowerCase().contains(event.query.toLowerCase()) ||
                hostel.placeName.toLowerCase().contains(event.query.toLowerCase());
            bool matchesFacilities = event.filters.facilities.isEmpty ||
                event.filters.facilities.every((facility) => hostel.facilities.contains(facility));
            bool matchesRoomTypes = event.filters.roomTypes.isEmpty ||
                hostel.rooms.any((room) => event.filters.roomTypes.contains(room['type']));
            bool matchesPrice = hostel.rooms.isEmpty ||
                hostel.rooms.any((room) =>
                room['rate'] != null &&
                    room['rate'] >= event.filters.priceRange.start &&
                    room['rate'] <= event.filters.priceRange.end);
            return matchesQuery && matchesFacilities && matchesRoomTypes && matchesPrice;
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