import 'package:flutter/material.dart';

class SearchFilterState {
  final List<String> facilities;
  final List<String> roomTypes;
  final RangeValues priceRange;

  SearchFilterState({
    required this.facilities,
    required this.roomTypes,
    required this.priceRange,
  });

  SearchFilterState copyWith({
    List<String>? facilities,
    List<String>? roomTypes,
    RangeValues? priceRange,
  }) {
    return SearchFilterState(
      facilities: facilities ?? this.facilities,
      roomTypes: roomTypes ?? this.roomTypes,
      priceRange: priceRange ?? this.priceRange,
    );
  }
}