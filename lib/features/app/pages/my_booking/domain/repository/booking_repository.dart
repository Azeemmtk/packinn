import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/my_booking/domain/entity/booking_entity.dart';

abstract class BookingRepository{
  Future<Either<Failure, List<BookingEntity>>> getMyBookings();
}