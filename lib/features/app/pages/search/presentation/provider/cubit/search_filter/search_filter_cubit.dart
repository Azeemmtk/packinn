import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/cubit/search_filter/search_filter_state.dart';

class SearchFilterCubit extends Cubit<SearchFilterState> {
  SearchFilterCubit()
      : super(SearchFilterState(
    distanceRange: const RangeValues(2, 20),
    facilities: [],
    roomTypes: [],
    priceRange: const RangeValues(1000, 10000),
    approvedOnly: false,
  ));

  void updateDistanceRange(RangeValues distanceRange) {
    emit(state.copyWith(distanceRange: distanceRange));
  }

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

  void toggleApprovedOnly(bool approvedOnly) {
    emit(state.copyWith(approvedOnly: approvedOnly));
  }

  void applyFilters() {
    // Emit current state to trigger UI update
    emit(state.copyWith());
  }

  void resetFilters() {
    emit(SearchFilterState(
      distanceRange: const RangeValues(2, 20),
      facilities: [],
      roomTypes: [],
      priceRange: const RangeValues(1000, 10000),
      approvedOnly: false,
    ));
  }
}