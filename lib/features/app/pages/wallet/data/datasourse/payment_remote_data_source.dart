import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packinn/core/error/exceptions.dart';
import '../model/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentModel>> getPayment(String uId);
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
}
