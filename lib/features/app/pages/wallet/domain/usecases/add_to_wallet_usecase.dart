import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repository/wallet_repository.dart';

class AddToWalletUseCase implements UseCase<void, AddToWalletParams> {
  final WalletRepository repository;

  AddToWalletUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToWalletParams params) async {
    return await repository.addToWallet(params.userId, params.amount, params.description);
  }
}

class AddToWalletParams {
  final String userId;
  final double amount;
  final String description;

  AddToWalletParams({required this.userId, required this.amount, required this.description});
}