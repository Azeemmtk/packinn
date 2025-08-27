import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repository/wallet_repository.dart';

class UpdateOccupantUseCase implements UseCase<void, UpdateOccupantParams> {
  final WalletRepository repository;

  UpdateOccupantUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateOccupantParams params) async {
    return await repository.updateOccupant(params.occupantId, params.hostelId, params.roomId, params.roomType);
  }
}

class UpdateOccupantParams {
  final String occupantId;
  final String hostelId;
  final String roomId;
  final String roomType;

  UpdateOccupantParams({
    required this.occupantId,
    required this.hostelId,
    required this.roomId,
    required this.roomType,
  });
}