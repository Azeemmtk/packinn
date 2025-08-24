import 'package:equatable/equatable.dart';
import '../../../../../../../../core/entity/hostel_entity.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<HostelEntity> hostels;

  SearchLoaded(this.hostels);

  @override
  List<Object?> get props => [hostels];
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}