import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../data/model/transaction model.dart';
import '../repository/wallet_repository.dart';

class GetTransactionsUseCase implements UseCase<List<TransactionModel>, String> {
  final WalletRepository repository;

  GetTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TransactionModel>>> call(String userId) async {
    return await repository.getTransactions(userId);
  }
}