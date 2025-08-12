import 'package:packinn/features/app/pages/search/presentation/provider/cubit/search_filter/search_filter_state.dart';

abstract class SearchEvent {}

class SearchHostelsEvent extends SearchEvent {
  final String query;
  final SearchFilterState filters;

  SearchHostelsEvent(this.query, this.filters);
}