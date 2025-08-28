import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/wallet/data/datasourse/occupant_edit_remote_data_source.dart';
import 'package:packinn/features/app/pages/wallet/data/datasourse/payment_remote_data_source.dart';
import 'package:packinn/features/app/pages/wallet/data/model/payment_model.dart';
import '../../domain/repository/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final OccupantEditRemoteDataSource remoteDataSource;
  final PaymentRemoteDataSource paymentRemoteDataSource;

  final FirebaseFirestore firestore;

  WalletRepositoryImpl(this.remoteDataSource, this.paymentRemoteDataSource,
      {FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> updateOccupant(String occupantId,
      String hostelId, String roomId, String roomType) async {
    try {
      await remoteDataSource.updateOccupant(
          occupantId, hostelId, roomId, roomType);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> savePayment(PaymentModel payment) async {
    try {
      print('===============${payment.hostelName}');
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(payment.id)
          .set(payment.toJson());
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to save payment'));
    }
  }

  @override
  Future<Either<Failure, List<PaymentModel>>> getPayments(String userId) async {
    try {
      print('implimentation===========$userId}');
      final payments = await paymentRemoteDataSource.getPayment(userId);
      return Right(payments);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updatePayment(String paymentId) async {
    try {
      await paymentRemoteDataSource.updatePayment(paymentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure ('Failed to update payment ${e.toString()}'));
    }
  }
}
