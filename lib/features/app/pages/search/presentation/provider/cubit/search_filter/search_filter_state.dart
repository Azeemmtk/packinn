import 'package:flutter/material.dart';

class SearchFilterState {
  final List<String> facilities;
  final List<String> roomTypes;
  final RangeValues priceRange;
  final RangeValues distanceRange;
  final BuildContext? context; // Added context field

  SearchFilterState({
    required this.facilities,
    required this.roomTypes,
    required this.priceRange,
    required this.distanceRange,
    this.context,
  });

  SearchFilterState copyWith({
    List<String>? facilities,
    List<String>? roomTypes,
    RangeValues? priceRange,
    RangeValues? distanceRange,
    BuildContext? context,
  }) {
    return SearchFilterState(
      facilities: facilities ?? this.facilities,
      roomTypes: roomTypes ?? this.roomTypes,
      priceRange: priceRange ?? this.priceRange,
      distanceRange: distanceRange ?? this.distanceRange,
      context: context ?? this.context,
    );
  }
}