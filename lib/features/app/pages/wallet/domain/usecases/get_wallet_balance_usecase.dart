import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repository/wallet_repository.dart';

class GetWalletBalanceUseCase implements UseCase<double, String> {
  final WalletRepository repository;

  GetWalletBalanceUseCase(this.repository);

  @override
  Future<Either<Failure, double>> call(String userId) async {
    return await repository.getWalletBalance(userId);
  }
}