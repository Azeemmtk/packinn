import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, void>> updateOccupant(String occupantId, String hostelId, String roomId, String roomType);
}