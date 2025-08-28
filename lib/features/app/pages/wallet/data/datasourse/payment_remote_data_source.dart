import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import '../../../../../../core/error/failures.dart';
import '../model/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentModel>> getPayment(String uId);
  Future<Either<Failure, void>> updatePayment(String paymentId);
}

class PaymentRemoteDataSourceImpl extends PaymentRemoteDataSource {
  final FirebaseFirestore firestore;

  PaymentRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<PaymentModel>> getPayment(String uId) async {
    try {
      print('datasource===========$uId}');
      final querySnapshot = await firestore
          .collection('payments')
          .where('userId', isEqualTo: uId)
          .get();
      final payments = querySnapshot.docs
          .map((doc) => PaymentModel.fromJson(doc.data()))
          .toList();
      print('===================${payments.length}');
      return payments;
    } catch (e) {
      throw ServerException('Failed to get payments: $e');
    }
  }

  @override
  Future<Either<Failure, void>> updatePayment(String paymentId) async{
    try{
      await firestore.collection('payments').doc(paymentId).update(
          {
            'paymentStatus': true,
          }
      );
      return Right(null);
    } catch (e){
      return Left(ServerFailure('Failed to update Payment: ${e.toString()}'));
    }
  }
}
