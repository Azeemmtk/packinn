import 'package:packinn/features/app/pages/search/presentation/provider/cubit/search_filter/search_filter_state.dart';

abstract class SearchEvent {}

class SearchHostelsEvent extends SearchEvent {
  final String query;

  SearchHostelsEvent(this.query);
}

class ApplyFiltersEvent extends SearchEvent {
  final SearchFilterState filters;

  ApplyFiltersEvent(this.filters);
}