import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/search/search_bloc.dart';
import '../../bloc/search/search_event.dart';
import 'search_filter_state.dart';

class SearchFilterCubit extends Cubit<SearchFilterState> {
  SearchFilterCubit()
      : super(SearchFilterState(
    facilities: [],
    roomTypes: [],
    priceRange: const RangeValues(1000, 10000),
  ));

  void toggleFacility(String facility) {
    final facilities = List<String>.from(state.facilities);
    if (facilities.contains(facility)) {
      facilities.remove(facility);
    } else {
      facilities.add(facility);
    }
    emit(state.copyWith(facilities: facilities));
  }

  void toggleRoomType(String roomType) {
    final roomTypes = List<String>.from(state.roomTypes);
    if (roomTypes.contains(roomType)) {
      roomTypes.remove(roomType);
    } else {
      roomTypes.add(roomType);
    }
    emit(state.copyWith(roomTypes: roomTypes));
  }

  void updatePriceRange(RangeValues priceRange) {
    emit(state.copyWith(priceRange: priceRange));
  }

  void applyFilters(BuildContext context, String searchQuery) {
    emit(state.copyWith());
    // Trigger a search with the current query and updated filters
    context.read<SearchBloc>().add(SearchHostelsEvent(searchQuery, state));
  }

  void resetFilters() {
    emit(SearchFilterState(
      facilities: [],
      roomTypes: [],
      priceRange: const RangeValues(1000, 10000),
    ));
  }
}