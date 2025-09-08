import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../datasourse/occupant_edit_remote_data_source.dart';
import '../datasourse/payment_remote_data_source.dart';
import '../datasourse/wallet_remote_data_source.dart';
import '../model/payment_model.dart';
import '../model/transaction model.dart';
import '../../domain/repository/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final OccupantEditRemoteDataSource remoteDataSource;
  final PaymentRemoteDataSource paymentRemoteDataSource;
  final WalletRemoteDataSource walletRemoteDataSource;
  final FirebaseFirestore firestore;

  WalletRepositoryImpl(
      this.remoteDataSource, this.paymentRemoteDataSource, this.walletRemoteDataSource,
      {FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> updateOccupant(String occupantId,
      String hostelId, String roomId, String roomType) async {
    try {
      await remoteDataSource.updateOccupant(occupantId, hostelId, roomId, roomType);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> savePayment(PaymentModel payment) async {
    try {
      print('===============${payment.hostelName}');
      await firestore.collection('payments').doc(payment.id).set(payment.toJson());
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to save payment'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentModel>>> getPayments(String userId) async {
    try {
      print('implimentation===========$userId');
      final payments = await paymentRemoteDataSource.getPayment(userId);
      return Right(payments);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updatePayment(String paymentId, String? paidVia) async {
    try {
      await paymentRemoteDataSource.updatePayment(paymentId, paidVia);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update payment ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> getWalletBalance(String userId) async {
    try {
      final balance = await walletRemoteDataSource.getWalletBalance(userId);
      print('========================balance==============$balance');
      return Right(balance);
    } catch (e) {
      return Left(ServerFailure('Failed to get wallet balance: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addToWallet(String userId, double amount, String description) async {
    try {
      await walletRemoteDataSource.addToWallet(userId, amount, description);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add to wallet: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deductFromWallet(String userId, double amount, String description, String? paymentId) async {
    try {
      await walletRemoteDataSource.deductFromWallet(userId, amount, description, paymentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to deduct from wallet: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getTransactions(String userId) async {
    try {
      final transactions = await walletRemoteDataSource.getTransactions(userId);
      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure('Failed to get transactions: $e'));
    }
  }
}