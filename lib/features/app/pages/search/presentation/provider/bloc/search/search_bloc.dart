import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/search_hostel.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchHostels searchHostels;

  SearchBloc({required this.searchHostels}) : super(SearchInitial()) {
    on<SearchHostelsEvent>(_onSearchHostels);
  }

  Future<void> _onSearchHostels(
      SearchHostelsEvent event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty &&
        event.filters.facilities.isEmpty &&
        event.filters.roomTypes.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final result =
          await searchHostels(SearchHostelParams(event.query, event.filters));
      emit(
        result.fold(
          (failure) => SearchError(failure.message),
          (hostels) => SearchLoaded(hostels),
        ),
      );
    } catch (e) {
      emit(SearchError('Unexpected error during search: $e'));
    }
  }
}
