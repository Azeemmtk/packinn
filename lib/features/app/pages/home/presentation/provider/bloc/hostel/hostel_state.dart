part of 'hostel_bloc.dart';

@immutable
sealed class HostelState extends Equatable {
  const HostelState();

  @override
  List<Object?> get props => [];
}

final class HostelInitial extends HostelState {
  const HostelInitial();
}

final class HostelLoading extends HostelState {
  const HostelLoading();
}

final class HostelLoaded extends HostelState {
  final List<HostelEntity> hostels;
  const HostelLoaded(this.hostels);

  @override
  List<Object?> get props => [hostels];
}

final class HostelError extends HostelState {
  final String message;
  const HostelError(this.message);

  @override
  List<Object?> get props => [message];
}