import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';  
import '../../../../../../core/usecases/usecase.dart';
import '../entity/booking_entity.dart';
import '../repository/booking_repository.dart';

class GetMyBookingsUseCase implements UseCase<List<BookingEntity>, NoParams> {
  final BookingRepository repository;

  GetMyBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(NoParams params) {
    return repository.getMyBookings();
  }
}