import 'package:equatable/equatable.dart';
import '../../../../../../../../core/entity/hostel_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<HostelEntity> hostels;

  const SearchLoaded(this.hostels);

  @override
  List<Object> get props => [hostels];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class AutocompleteSuggestionsLoaded extends SearchState {
  final List<String> suggestions;

  const AutocompleteSuggestionsLoaded(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}