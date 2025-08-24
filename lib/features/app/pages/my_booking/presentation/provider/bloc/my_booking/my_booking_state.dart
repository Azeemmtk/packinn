import 'package:equatable/equatable.dart';
import '../../../../domain/entity/booking_entity.dart';

abstract class MyBookingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsLoaded extends MyBookingsState {
  final List<BookingEntity> bookings;

  MyBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class MyBookingsError extends MyBookingsState {
  final String message;

  MyBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}