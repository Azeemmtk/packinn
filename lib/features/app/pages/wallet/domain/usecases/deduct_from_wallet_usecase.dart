import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repository/wallet_repository.dart';

class DeductFromWalletUseCase implements UseCase<void, DeductFromWalletParams> {
  final WalletRepository repository;

  DeductFromWalletUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeductFromWalletParams params) async {
    return await repository.deductFromWallet(params.userId, params.amount, params.description, params.paymentId);
  }
}

class DeductFromWalletParams {
  final String userId;
  final double amount;
  final String description;
  final String? paymentId;

  DeductFromWalletParams({required this.userId, required this.amount, required this.description, this.paymentId});
}