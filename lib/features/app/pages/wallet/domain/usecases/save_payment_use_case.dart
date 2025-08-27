import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/wallet/domain/repository/wallet_repository.dart';

import '../../data/model/payment_model.dart';

class SavePaymentUseCase implements UseCase<void, PaymentModel> {
  final WalletRepository repository;

  SavePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(PaymentModel params) async {
    return await repository.savePayment(params);
  }
}