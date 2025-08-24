import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repository/payment_repository.dart';

class UpdateOccupantUseCase implements UseCase<void, UpdateOccupantParams> {
  final PaymentRepository repository;

  UpdateOccupantUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateOccupantParams params) async {
    return await repository.updateOccupant(params.occupantId, params.hostelId, params.roomId);
  }
}

class UpdateOccupantParams {
  final String occupantId;
  final String hostelId;
  final String roomId;

  UpdateOccupantParams({
    required this.occupantId,
    required this.hostelId,
    required this.roomId,
  });
}