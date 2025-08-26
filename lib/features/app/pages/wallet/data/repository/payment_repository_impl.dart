import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/wallet/data/datasourse/occupant_edit_remote_data_source.dart';
import 'package:packinn/features/app/pages/wallet/data/model/payment_model.dart';
import '../../domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final OccupantEditRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);



  @override
  Future<Either<Failure, void>> updateOccupant(String occupantId, String hostelId, String roomId, String roomType) async {
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
      await FirebaseFirestore.instance.collection('payments').doc(payment.id).set(payment.toJson());
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to save payment'));
    }
  }
  
  
}