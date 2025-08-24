part of 'hostel_bloc.dart';

@immutable
sealed class HostelEvent extends Equatable {
  const HostelEvent();

  @override
  List<Object?> get props => [];
}

final class FetchHostelsData extends HostelEvent {}