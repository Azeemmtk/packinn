import 'package:flutter/material.dart';

class SearchFilterState {
  final RangeValues distanceRange;
  final List<String> facilities;
  final List<String> roomTypes;
  final RangeValues priceRange;
  final bool approvedOnly;

  SearchFilterState({
    required this.distanceRange,
    required this.facilities,
    required this.roomTypes,
    required this.priceRange,
    required this.approvedOnly,
  });

  SearchFilterState copyWith({
    RangeValues? distanceRange,
    List<String>? facilities,
    List<String>? roomTypes,
    RangeValues? priceRange,
    bool? approvedOnly,
  }) {
    return SearchFilterState(
      distanceRange: distanceRange ?? this.distanceRange,
      facilities: facilities ?? this.facilities,
      roomTypes: roomTypes ?? this.roomTypes,
      priceRange: priceRange ?? this.priceRange,
      approvedOnly: approvedOnly ?? this.approvedOnly,
    );
  }
}