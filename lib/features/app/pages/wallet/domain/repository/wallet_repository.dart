import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../data/model/payment_model.dart';
import '../../data/model/transaction model.dart';

abstract class WalletRepository {
  Future<Either<Failure, void>> updateOccupant(String occupantId, String hostelId, String roomId, String roomType);
  Future<Either<Failure, void>> savePayment(PaymentModel payment);
  Future<Either<Failure, List<PaymentModel>>> getPayments(String userId);
  Future<Either<Failure, void>> updatePayment(String paymentId, String? paidVia); // Updated to include paidVia
  Future<Either<Failure, double>> getWalletBalance(String userId);
  Future<Either<Failure, void>> addToWallet(String userId, double amount, String description);
  Future<Either<Failure, void>> deductFromWallet(String userId, double amount, String description, String? paymentId);
  Future<Either<Failure, List<TransactionModel>>> getTransactions(String userId);
}