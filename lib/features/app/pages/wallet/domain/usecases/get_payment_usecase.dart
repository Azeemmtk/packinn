import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/wallet/data/model/payment_model.dart';
import 'package:packinn/features/app/pages/wallet/domain/repository/wallet_repository.dart';

class GetPaymentsUseCase implements UseCase<List<PaymentModel>, String> {
  final WalletRepository repository;

  GetPaymentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PaymentModel>>> call(String userId) async {
    return await repository.getPayments(userId);
  }
}