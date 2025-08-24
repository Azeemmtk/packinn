import 'package:equatable/equatable.dart';

abstract class MyBookingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMyBookings extends MyBookingsEvent {}