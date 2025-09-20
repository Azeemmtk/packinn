import 'package:equatable/equatable.dart';

import '../../cubit/search_filter/search_filter_state.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchHostelsEvent extends SearchEvent {
  final String query;
  final SearchFilterState filters;

  const SearchHostelsEvent(this.query, this.filters);

  @override
  List<Object> get props => [query, filters];
}

class GetAutocompleteSuggestionsEvent extends SearchEvent {
  final String query;

  const GetAutocompleteSuggestionsEvent(this.query);

  @override
  List<Object> get props => [query];
}