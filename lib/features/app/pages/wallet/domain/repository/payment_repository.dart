import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../data/model/payment_model.dart';

abstract class PaymentRepository {
  Future<Either<Failure, void>> updateOccupant(String occupantId, String hostelId, String roomId, String roomType);
  Future<Either<Failure, void>> savePayment(PaymentModel payment);
}


